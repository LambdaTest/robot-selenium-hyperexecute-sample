*** Settings ***

Resource  ../Resources/Common.robot

Test Setup  Common.Open test browser for Selenium Playground
Test Teardown  Common.Close test browser

*** Variables ***

*** Test Cases ***

Demonstration of Robot framework on Selenium Playground
	[Timeout]   ${TIMEOUT}
	Page should contain element  xpath://a[.='Input Form Submit']

	Click link  xpath=//a[.='Input Form Submit']
	Page should contain element  name:name
	# Enter details in the input form

	# Name
	Input text  name:name   TestName
	Sleep   5

	# Email
	${email}   Set Variable    inputEmail4
	Input text  ${email}       testing@gmail.com

    # Password
	${passwd}   Set Variable    //input[@name='password']
	Input text  ${passwd}       Password1

	# Company
	${company}  Set Variable    //input[@id='company']
	Input text  ${company}      LambdaTest

	# Website
	${website}  Set Variable    css=#websitename
	Input text  ${website}      https://wwww.lambdatest.com

	# Country
	${country}   Set Variable    name:country
	select from list by value    ${country}     US

    # City
	${city}   Set Variable    //input[@id='inputCity']
	Input text  ${city}       San Jose

	# Address 1
	${address1}  Set Variable    id:inputAddress1
	Input text  ${address1}      Googleplex, 1600 Amphitheatre Pkwy

	# Website
	${address2}  Set Variable     id:inputAddress2
	Input text  ${address2}       Mountain View, CA 94043

	# State
	${state}      Set Variable      css=#inputState
	Input text    ${state}          California

    # City
	${city}   Set Variable    //input[@id='inputCity']
	Input text  ${city}       San Jose

	# Zip Code
	${address1}  Set Variable    css=#inputZip
	Input text  ${address1}      94088
