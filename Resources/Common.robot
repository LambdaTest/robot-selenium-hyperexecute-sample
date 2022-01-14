*** Settings ***
Library  SeleniumLibrary
Library  LambdaTestStatus.py

*** Variables ***

@{_tmp}
    ...  browserName: ${browserName},
    ...  platform: ${platform},
    ...  version: ${version},
    ...  visual: ${visual},
    ...  network: ${network},
    ...  console: ${console},
    ...  name: RobotFramework LambdaTest

${CAPABILITIES}     ${EMPTY.join(${_tmp})}
${REMOTE_URL}       https://%{LT_USERNAME}:%{LT_ACCESS_KEY}@hub.lambdatest.com/wd/hub
${TIMEOUT}          3000

*** Keywords ***

Open test browser
    [Timeout]   ${TIMEOUT}
    Open browser  https://lambdatest.github.io/sample-todo-app/
    ...  remote_url=${REMOTE_URL}
    ...  desired_capabilities=${CAPABILITIES}

Open test browser for Selenium Playground
    [Timeout]   ${TIMEOUT}
    Open browser  https://www.lambdatest.com/selenium-playground/
    ...  remote_url=${REMOTE_URL}
    ...  desired_capabilities=${CAPABILITIES}    

Close test browser
    Run keyword if  '${REMOTE_URL}' != ''
    ...  Report Lambdatest Status
    ...  ${TEST_NAME} 
    ...  ${TEST_STATUS} 
    Close all browsers