*** Settings ***
Library    SeleniumLibrary

*** Variables ***
${URL}                          https://ncfu.test.folipro.ru/
${BROWSER}                      chrome
@{TABPANNEL_TEXT}               Дизайн  Медиакоммуникации  Цифровые решения
${UNAUTHORIZED_USER_TAB}        Проекты
${AUTHORIZED_TAB_NAME}          Мои проекты
${SEARCH_TEXT}                  игры
${UNAUTHORIZED_USER_PROJECT}    3
${AUTHORIZED_USER_PROJECT}      3
${STUDENT_LOGIN}                test_student_31
${STUDENT_PASSWORD}             testlogin

*** Test Cases ***
Test Unauthorized User
    [Documentation]    Взаимодействие неавторизованного пользователя с сайтом.
    Open Configured Browser
    Clicks On Tabpannel Buttons
    Switch Tab    ${UNAUTHORIZED_USER_TAB}
    Project Search
    Check Project Exists    ${AUTHORIZED_USER_PROJECT}    False
    Close Browser

Test Authorized User
    [Documentation]    Взаимодействие авторизованного пользователя с сайтом.
    Open Configured Browser
    Authorization
    Switch Tab    ${AUTHORIZED_TAB_NAME}
    Check Project Exists    ${AUTHORIZED_USER_PROJECT}    True
    Close Browser

*** Keywords ***
Create Chrome Options
    [Documentation]    Создает и возвращает объект настроек для браузера Chrome.
    ${options}  Evaluate  selenium.webdriver.ChromeOptions()
    RETURN    ${options}

Open Configured Browser
    [Documentation]    Открывает браузер с заранее заданными параметрами.
    ${options}    Create Chrome Options
    Call Method    ${options}  add_argument  --start-maximized
    Call Method    ${options}  set_capability  pageLoadStrategy  eager
    Set Selenium Speed    1s

    Open Browser    url=${URL}    browser=${BROWSER}    options=${options}

Authorization
    [Documentation]    Выполняет авторизацию пользователя на сайте.
    ${loginBtn}    Get WebElement    xpath://span[text()="Войти"]
    Wait Until Element Is Visible    ${loginBtn}
    Click Element    ${loginBtn}
    ${loginInput}    Get WebElement    xpath://input[@id="login"]
    Wait Until Element Is Visible    ${loginInput}
    Input Text    ${loginInput}    ${STUDENT_LOGIN}
    ${passwordInput}    Get WebElement    xpath://input[@id="password"]
    Wait Until Element Is Visible    ${passwordInput}
    Input Text    ${passwordInput}    ${STUDENT_PASSWORD}
    ${submitBtn}    Get WebElement    xpath://button[@type="submit"]
    Wait Until Element Is Visible    ${submitBtn}
    Click Element    ${submitBtn}

Clicks On Tabpannel Buttons
    [Documentation]    Кликает по кнопкам на панели вкладок, заданным в переменной @{TABPANNEL_TEXT}.
    FOR  ${btnText}  IN  @{TABPANNEL_TEXT}
        ${tabPannelBtn}    Get WebElement    xpath://span[text()="${btnText}"]
        Wait Until Element Is Visible    ${tabPannelBtn}
        Click Element    ${tabPannelBtn}
        Execute JavaScript    window.scrollTo(0, 0);
    END

Switch Tab
    [Documentation]    Переключается на вкладку с заданным именем.
    [Arguments]    ${tabName}
    ${tabLink}    Get WebElement    xpath://a[text()="${tabName}"]
    Wait Until Element Is Visible    ${tabLink}
    Click Element    ${tabLink}

Project Search
    [Documentation]    Выполняет поиск проекта по заданному тексту.
    ${searchInput}    Get WebElement    xpath://input[@placeholder="Поиск проекта"]
    Wait Until Element Is Visible    ${searchInput}
    Input Text    ${searchInput}    ${SEARCH_TEXT}
    ${submitBtn}    Get WebElement    xpath://button[@type="submit"]
    Wait Until Element Is Visible    ${submitBtn}
    Click Element    ${submitBtn}

Check Project Exists
    [Documentation]   Проверяет, существует ли проект с заданным идентификатором.
    [Arguments]    ${projectId}    ${is_authorized}
    ${base_path}    Run Keyword If   ${is_authorized}   Set Variable   /dashboard/projects/   ELSE   Set Variable   /projects/
    ${xpath}    Set Variable   xpath://a[@href="${base_path}${projectId}"]
    ${element_exists}   Run Keyword And Return Status   Element Should Be Visible   ${xpath}
    Should Be True   ${element_exists}   Проект с id=${projectId} не найден
