*** Settings ***
Library     RPA.Robocorp.Vault
Library     String
Resource    shared.robot


*** Keywords ***
Log in to Ryan's Club website
    ${secret}=    Get Secret    ryansClub
    Fill Secret    id=email    ${secret}[username]
    Fill Secret    id=password    ${secret}[password]
    Sleep    0.5s
    Click    id=login

Accept cookies
    Click    id=onetrust-accept-btn-handler

Open the credit card dump page
    Click    css=a.btn[href="automationanywherelabs-ryansclub_ccdumps_349473.html"]

Scrape credit card dump data
    ${page_count}=    Get page count
    ${credit_card_dump_data}=    Create List
    FOR    ${counter}    IN RANGE    1    ${page_count} + 1
        ${rows}=    Get Elements    css=#transactions tr
        FOR    ${row}    IN    @{rows}
            ${card_number}=    Get cell text    ${row}    1
            ${card_number_start}=    Fetch From Left    ${card_number}    *
            ${expiration}=    Get cell text    ${row}    2
            ${level}=    Get cell text    ${row}    3
            ${brand}=    Get cell text    ${row}    4
            ${card_type}=    Get cell text    ${row}    5
            ${last_name}=    Get cell text    ${row}    6
            ${city_and_state}=    Get cell text    ${row}    7
            ${city}=    Fetch From Left    ${city_and_state}    ;
            ${state}=    Fetch From Right    ${city_and_state}    ;
            ${zip}=    Get cell text    ${row}    8
            ${country}=    Get cell text    ${row}    9
            ${data}=
            ...    Create Dictionary
            ...    card_number=${card_number}
            ...    card_number_start=${card_number_start}
            ...    expiration=${expiration}
            ...    level=${level}
            ...    brand=${brand}
            ...    card_type=${card_type}
            ...    last_name=${last_name}
            ...    city=${city}
            ...    state=${state}
            ...    zip=${zip}
            ...    country=${country}
            Append To List    ${credit_card_dump_data}    ${data}
        END
        IF    ${counter} != ${page_count}    Click    css=li.pager:last-child
    END
    RETURN    ${credit_card_dump_data}

Get page count
    ${page_count}=
    ...    Get Attribute
    ...    css=.dataTable-pagination .ellipsis + li a
    ...    data-page
    RETURN    ${page_count}

Get cell text
    [Arguments]    ${row}    ${cell_index}
    ${text}=    Get Text    ${row} >> css=td:nth-child(${cell_index})
    ${text}=    Strip String    ${text}
    RETURN    ${text}
