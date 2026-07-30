*** Settings ***

Resource    ../Resources/Common.robot

Test Setup       Common.Open Simple Form Demo
Test Teardown    Common.Close test browser

*** Variables ***

${MESSAGE}    Welcome to TestMu AI

*** Test Cases ***

Verify Simple Form Demo
    [Timeout]    ${TIMEOUT}

    Wait Until Element Is Visible    id:user-message    20s

    Input Text    id:user-message    ${MESSAGE}

    Click Button    id:showInput

    Wait Until Element Is Visible    id:message    20s

    ${response}=    Get Text    id:message

    Should Be Equal As Strings    ${response}    ${MESSAGE}