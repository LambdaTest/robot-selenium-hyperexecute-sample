*** Settings ***
Library    SeleniumLibrary
Library    LambdaTestStatus.py

*** Variables ***

@{_tmp}
...    browserName: ${browserName},
...    platform: ${platform},
...    version: ${version},
...    visual: ${visual},
...    network: ${network},
...    console: ${console},
...    name: RobotFramework TestMu AI

${CAPABILITIES}    ${EMPTY.join(${_tmp})}
${REMOTE_URL}      https://%{LT_USERNAME}:%{LT_ACCESS_KEY}@hub.lambdatest.com/wd/hub
${TIMEOUT}         3000

*** Keywords ***

Open Simple Form Demo
    [Timeout]    ${TIMEOUT}
    Open Browser
    ...    https://www.testmuai.com/selenium-playground/simple-form-demo/
    ...    remote_url=${REMOTE_URL}
    ...    desired_capabilities=${CAPABILITIES}

Open Input Form Demo
    [Timeout]    ${TIMEOUT}
    Open Browser
    ...    https://www.testmuai.com/selenium-playground/input-form-demo/
    ...    remote_url=${REMOTE_URL}
    ...    desired_capabilities=${CAPABILITIES}

Close test browser
    Run Keyword If    '${REMOTE_URL}' != ''
    ...    Report Lambdatest Status
    ...    ${TEST_NAME}
    ...    ${TEST_STATUS}

    Close All Browsers