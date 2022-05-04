*** Settings ***
Library     OperatingSystem
Resource    shared.robot


*** Variables ***
${CANCELLATIONS_CSV}=       ${OUTPUT_DIR}${/}cancellations.csv


*** Keywords ***
Fill in cancellations CSV
    [Arguments]    ${customers}
    Copy File
    ...    %{ROBOT_ROOT}${/}resources${/}cancellations_template.csv
    ...    ${CANCELLATIONS_CSV}
    FOR    ${customer}    IN    @{customers}
        ${comma_separated_string}=
        ...    Evaluate
        ...    ','.join(map(str, ${customer}))
        Append To File
        ...    ${CANCELLATIONS_CSV}
        ...    ${comma_separated_string}${\n}
    END

Upload cancellations CSV
    Upload File By Selector    id=fileToUpload    ${CANCELLATIONS_CSV}
    Click    id=btnUploadFile
