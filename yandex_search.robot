*** Settings ***
Library  SeleniumLibrary
Library  WebDriverSetup.py
Library  Process

*** Variables ***
${BROWSER}  chrome
${CHROME_DRIVER_PATH}
${CHROME_OPTIONS}
${CHROME_SERVICE}
${SEARCH_ENGINE_URL}  https://ya.ru
${SEARCH_QUERY}  habr
${SEARCHED_SITE_URL}  https://habr.com
${HABR_SEARCH_QUERY}  TEXT

*** Test Cases ***
HabrCheckElements
    Open Configured Browser  ${SEARCHED_SITE_URL}
    Habr Menu Button Clicks
    Habr Text Search  ${HABR_SEARCH_QUERY}

YandexSearchSite
    Open Configured Browser  ${SEARCH_ENGINE_URL}
    Search Site  ${SEARCH_QUERY}  ${SEARCHED_SITE_URL}
    Sleep  2s
    Close Browser

*** Keywords ***
Open Configured Browser
    [Arguments]  ${site_url}
    Install Chrome Driver
    Create Chrome Options
    Create Chrome Service

    # Настройка браузера
    Call Method  ${CHROME_OPTIONS}  add_argument  --start-maximized
    Call Method  ${CHROME_OPTIONS}  set_capability  pageLoadStrategy  eager
    Set Selenium Speed  1s

    Open Browser  ${site_url}  ${BROWSER}  options=${CHROME_OPTIONS}  service=${CHROME_SERVICE}

Search Site
    [Arguments]  ${search_query}  ${SEARCHED_SITE_URL}
    Input Text  id=text  ${search_query}\n
    Wait Until Element Is Visible  xpath://a[contains(@href, "${SEARCHED_SITE_URL}")]
    Log  Сайт ${SEARCHED_SITE_URL} успешно найден

Install Chrome Driver
    # Применение функции из WebDriverSetup для установки новой версии webdriver
    ${chrome_driver_path}  Get Chrome Driver Path
    Set Test Variable  ${CHROME_DRIVER_PATH}  ${chrome_driver_path}

Create Chrome Options
    ${options}  Evaluate  selenium.webdriver.ChromeOptions()
    Set Test Variable  ${CHROME_OPTIONS}   ${options}

Create Chrome Service
    ${service}  Create Service  chrome_driver_path=${CHROME_DRIVER_PATH}
    Set Test Variable  ${CHROME_SERVICE}   ${service}

Habr Menu Button Clicks
    FOR  ${link_text}  IN  Моя лента  Все потоки  Разработка  Администрирование
        Click Link  xpath://a[text()="${link_text}"]
        Log  Клик по кнопке с текстом "${link_text}" на сайте habr успешно выполнен
        Sleep  1
    END

Habr Text Search
    [Arguments]  ${habr_search_query}
    Click Link  xpath://a[@data-test-id="search-button"]
    Input Text  xpath://form[contains(@action, "search")]//input[@name="q"]  ${habr_search_query}
    Click Element  xpath://form[contains(@action, "search")]//span

    Log  Поиск текста "${habr_search_query}" на сайте habr умпешно выполнен
