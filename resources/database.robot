*** Settings ***
Library     RPA.Database
Library     RPA.HTTP
Resource    shared.robot


*** Variables ***
${CUSTOMER_DATABASE}=       ${OUTPUT_DIR}${/}CustomerData.db


*** Keywords ***
Download the customer database
    ${database_download_url}=
    ...    Get Attribute
    ...    css=a >> text="Customer Database Download"
    ...    href
    RPA.HTTP.Download    ${database_download_url}    ${CUSTOMER_DATABASE}

Query compromised customers from database
    [Arguments]    ${customers}
    Connect To Database    sqlite3    ${CUSTOMER_DATABASE}
    ${compromised_customers}=    Create List
    FOR    ${customer}    IN    @{customers}
        ${query}=    Catenate    SEPARATOR=${SPACE}
        ...    SELECT
        ...    cu.customer_id,
        ...    cu.first_name,
        ...    cu.last_name,
        ...    ca.card_number,
        ...    ca.cvv,
        ...    ca.brand
        ...    FROM customer_details cu
        ...    JOIN card_details ca
        ...    ON cu.customer_id = ca.id
        ...    WHERE cu.last_name = "${customer}[last_name]"
        ...    AND cu.country = "${customer}[country]"
        ...    AND cu.zip = "${customer}[zip]"
        ...    AND cu.city = "${customer}[city]"
        ...    AND cu.state = "${customer}[state]"
        ...    AND ca.level = "${customer}[level]"
        ...    AND ca.brand = "${customer}[brand]"
        ...    AND ca.card_number LIKE "${customer}[card_number_start]%"
        ...    AND ca.expiration = "${customer}[expiration]"
        ...    AND ca.card_type = "${customer}[card_type]"
        ${rows}=    Query    ${query}    as_table=False
        IF    ${rows}
            Append To List    ${compromised_customers}    ${rows}[0]
        END
    END
    RETURN    ${compromised_customers}
