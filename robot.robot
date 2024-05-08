*** Settings ***
Library           OperatingSystem
Library           RequestsLibrary  # For making HTTP requests
Library           JSONLibrary      # For handling JSON payloads

Suite Setup       Initialize Setup
Suite Teardown    Cleanup

*** Variables ***
${bucket_name}     my_bucket
${server}          http://195.35.23.236:8086
${org}             wasiq

*** Test Cases ***
Store Metrics
    [Documentation]    A test case to store metrics in InfluxDB.
    Log                Starting metrics storage

    ${metrics}=        Create Dictionary   performance=95.0    success_rate=98.0    error_rate=2.0
    ${time}=           Get Current Date
    ${timestamp}=      Format Time   ${time}   %Y-%m-%dT%H:%M:%SZ

    ${data}=           Create Dictionary   time=${timestamp}
                      ...                 metrics=${metrics}

    Store Data In InfluxDB   ${data}

*** Keywords ***
Initialize Setup
    [Documentation]    Prepares the setup for testing.
    # No specific setup actions needed here for now

Cleanup
    [Documentation]    Cleans up after the suite.
    # No specific cleanup actions needed for now

Store Data In InfluxDB
    [Arguments]         ${data}
    [Documentation]     Stores data into InfluxDB 2.x via HTTP.

    ${json_data}=       Convert To JSON   ${data}

    RequestsLibrary.Session   Create Session   influxdb   ${server}
    ${response}=       Post Request   influxdb   "/api/v2/write?org=${org}&bucket=${wasiq}&precision=ms"   headers={"Authorization": "Token ${youaAy8zrhz7av6XCJjkzGVlVdp5R1nGBpMnDnULOBU5NevztqPZfa8DWxi0gg2OCOJ-rgjot6xWdhNx7H-pKA==}"}   data=${json_data}

    Log Response Content   ${response}
