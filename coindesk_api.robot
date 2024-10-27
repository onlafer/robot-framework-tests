*** Settings ***
Library  RequestsLibrary
Library  Collections

*** Variables ***
${BASE_URL}  https://api.coindesk.com/v1/bpi
${CURRENCY}  GBP

*** Test Cases ***
Test BTC Currency Exchange Rate
    ${response}  GET Request  ${BASE_URL}/currentprice.json
    ${bpi}  Get From Dictionary  ${response.json()}  bpi

    ${usd_rate}  Get From Dictionary  ${bpi["USD"]}  rate
    ${gbp_rate}  Get From Dictionary  ${bpi["GBP"]}  rate
    ${eur_rate}  Get From Dictionary  ${bpi["EUR"]}  rate

    Log  Стоимость 1 BTC на данный момент составляет ${usd_rate} USD, ${gbp_rate} GBP, ${eur_rate} EUR

Test GBP Сurrent Exchange Rate
    ${response}  GET Request  ${BASE_URL}/currentprice/${CURRENCY}.json

    ${bpi}  Get From Dictionary  ${response.json()}  bpi
    ${rate}  Get From Dictionary  ${bpi["USD"]}  rate

    Log  Стоимость 1 ${CURRENCY} на данный момент составляет ${rate} USD

*** Keywords ***
GET Request
    [Arguments]  ${url}
    ${response}  GET  ${url}
    Should Be Equal As Integers  ${response.status_code}  200
    Log  ${response.content}
    RETURN  ${response}