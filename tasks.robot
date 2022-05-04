*** Settings ***
Documentation       Completes the Cyber Loss Prevention challenge.

Resource            csv.robot
Resource            database.robot
Resource            scraper.robot
Resource            shared.robot


*** Tasks ***
Complete the Cyber Loss Prevention challenge
    ${eagle_one_financial_page}=    Open the Eagle One Financial website
    Open the Ryan's Club website
    Log in to Ryan's Club website
    Accept cookies
    Open the credit card dump page
    ${credit_card_dump_data}=    Scrape credit card dump data
    Switch Page    ${eagle_one_financial_page}[page_id]
    Download the customer database
    ${compromised_customers}=
    ...    Query compromised customers from database
    ...    ${credit_card_dump_data}
    Fill in cancellations CSV    ${compromised_customers}
    Upload cancellations CSV
    Take a screenshot of the result


*** Keywords ***
Open the Eagle One Financial website
    New Context    userAgent=Chrome/100.0.4896.75
    ${eagle_one_financial_page}=
    ...    New Page
    ...    https://developer.automationanywhere.com/challenges/automationanywherelabs-cyberlossprevention.html
    RETURN    ${eagle_one_financial_page}

Open the Ryan's Club website
    Click    text="Ryan's Club Login"
    Switch Page    NEW

Take a screenshot of the result
    Sleep    1 second
    Take Screenshot    selector=css=#myModal .modal-content
