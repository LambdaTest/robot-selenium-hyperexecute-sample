*** Settings ***

Resource    ../Resources/Common.robot

Test Setup       Common.Open Input Form Demo
Test Teardown    Common.Close test browser

*** Test Cases ***

Demonstration of Robot framework on Selenium Playground
    [Timeout]    ${TIMEOUT}

    Wait Until Element Is Visible    id:name    20s

    Input Text    id:name    TestName
    Input Text    id:inputEmail4    testing@gmail.com
    Input Text    xpath=//input[@name='password']    Password1
    Input Text    id:company    LambdaTest
    Input Text    id:websitename    https://www.testmuai.com

    Select From List By Value    name:country    US

    Input Text    id:inputCity    San Jose
    Input Text    id:inputAddress1    Googleplex, 1600 Amphitheatre Pkwy
    Input Text    id:inputAddress2    Mountain View, CA 94043
    Input Text    id:inputState    California
    Input Text    id:inputZip    94088

    Sleep    2s