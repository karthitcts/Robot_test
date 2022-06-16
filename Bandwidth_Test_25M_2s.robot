*** Settings ***
Documentation     This is a demo automation for Optus Network Testing
Library           Selenium2Library
Library           SSHLibrary
Library           String
Library           Collections
Library           OperatingSystem
Library           DateTime

*** Variables ***
${Path} =  D:\\Test Automation\\Optus Demo\\Tests\\Optus_RFC_Network_Test\\EvolvePlus\\Results\\Bandwidth_Test_25M_2s
${Server_IP} =  10.10.10.9
${Client_IP} =  10.10.10.10
${Server_User} =  Administrator
${Server_Pwd} =  Tata@2018
${Client_User} =  ashwajit.bhoutkar
${Client_Pwd} =  Drinkbeer@20
@{BandwidthList}=  Create List
${Junk} =  0.0-

*** Test Cases ***
Network Bandwidth Demo
    [Documentation]  The purpose of the test is to calculate network bandwidth between two endpoints
    Create File  ${Path}/Result.txt  ${\n}${\n}****TCP BANDWIDTH TEST RESULTS ****${\n}${\n}
    ${datestart} =  Get Current Date  UTC  +10 hours

    Bandwidth Test 64
    Close All Connections
    Bandwidth Test 128
    Close All Connections
    Bandwidth Test 256
    Close All Connections
    Bandwidth Test 512
    Close All Connections
    Bandwidth Test 1024
    Close All Connections
    Bandwidth Test 1280
    Close All Connections
    Bandwidth Test 1518
    Close All Connections
    Sleep  1s

    ${dateend} =  Get Current Date  UTC  +10 hours
    Create File  ${Path}/SummaryResult.txt  ${\n}
    Append To File  ${Path}/SummaryResult.txt  ************************ THROUGHPUT TEST 25 Mb Badwidth, 2s Duration *************************${\n}${\n}${\n}
    Append To File  ${Path}/SummaryResult.txt  Customer Reference Number: EVOLVE PLUS TCTS Test Customer${\n}
    Append To File  ${Path}/SummaryResult.txt  Start Date and Time: ${datestart}${\n}
    Append To File  ${Path}/SummaryResult.txt  End Date and Time: ${dateend}${\n}
    Append To File  ${Path}/SummaryResult.txt  Testing Layer: Layer3${\n}
    Append To File  ${Path}/SummaryResult.txt  Server IP: ${Server_IP}${\n}
    Append To File  ${Path}/SummaryResult.txt  Client IP: ${Client_IP}${\n}
    Append To File  ${Path}/SummaryResult.txt  UDP Ports: 5001${\n}
    Append To File  ${Path}/SummaryResult.txt  Frames: 64, 128, 256, 512, 1024, 1280, 1518${\n}${\n}

    Append To File  ${Path}/SummaryResult.txt  ByteSize${SPACE}${SPACE}FrameDuration${SPACE}${SPACE}DATA Tx${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}Bandwidth${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}Jitter${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}FrameLoss${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}Status${\n}
    Append To File  ${Path}/SummaryResult.txt  ----------------------------------------------------------------------------------${\n}

    :FOR  ${Index}  IN RANGE  1  8
    \  Append To File  ${Path}/SummaryResult.txt  ${\n}@{BandwidthList}[${Index}]
    \  ${Index} =  Evaluate  ${Index}+1

*** Keywords ***

Bandwidth Test 64
    ${Traffic_Server} =  Open Connection  ${Server_IP}
    Login  ${Server_User}  ${Server_Pwd}
    Start Command  iperf -s -u
    Sleep  1s
    ${Traffic_Client} =  Open Connection  ${Client_IP}
    Login  ${Client_User}  ${Client_Pwd}
    Start Command  iperf -c ${Server_IP} -i 2 -b 25Mb -u -w 64 -t 2
    Sleep  3s
    ${TCP_Client} =  Read Command Output
    @{TestList} =  Split To Lines  ${TCP_Client}
    ${List_Length} =  Get Length  ${TestList}
    Append To File  ${Path}/Result.txt  ${\n}${\n}****Results for 64 byte Size with rate 25 Mbps****${\n}
    Append To File  ${Path}/Result.txt  ${\n}@{TestList}[0]
    :FOR  ${Index}  IN RANGE  1  ${List_Length}
    \  Append To File  ${Path}/Result.txt  ${\n}@{TestList}[${Index}]
    \  ${Index} =  Evaluate  ${Index}+1

    ${Summary} =  Convert To String  @{TestList}[${List_Length-1}]
    ${Summary} =  Remove String  ${Summary}  ${Junk}
    ${Summary} =  Replace String  ${Summary}  3]  64Bytes${SPACE}${SPACE}
    ${Summary} =  Remove String  ${Summary}  [
    ${Summary} =  Strip String  ${Summary}

    ${Status} =  Split String  ${Summary}  ms
    ${Status} =  Get From List  ${Status}  1

    ${Status} =  Split String  ${Status}  /
    ${Status} =  Get From List  ${Status}  0
    ${Status} =  Convert To String  ${Status}
    ${Status} =  Strip String  ${Status}
    ${Result} =  Set Variable If  ${Status} == 0  Pass  Fail
    ${Summary} =  Set Variable  ${Summary}${SPACE}${SPACE}${SPACE}${Result}

    Append To List  ${BandwidthList}  ${Summary}
    Log List  ${BandwidthList}



Bandwidth Test 128
    ${Traffic_Server} =  Open Connection  ${Server_IP}
    Login  ${Server_User}  ${Server_Pwd}
    Start Command  iperf -s -u
    Sleep  1s
    ${Traffic_Client} =  Open Connection  ${Client_IP}  prompt=>
    Login  ${Client_User}  ${Client_Pwd}
    Start Command  iperf -c ${Server_IP} -i 10 -b 25Mb -u -w 128 -t 2
    Sleep  3s
    ${TCP_Client} =  Read Command Output
    @{TestList} =  Split To Lines  ${TCP_Client}
    ${List_Length} =  Get Length  ${TestList}
    Append To File  ${Path}/Result.txt  ${\n}${\n}****Results for 128 byte Size with**** rate 25 Mbps****${\n}
    Append To File  ${Path}/Result.txt  ${\n}@{TestList}[0]
    :FOR  ${Index}  IN RANGE  1  ${List_Length}
    \  Append To File  ${Path}/Result.txt  ${\n}@{TestList}[${Index}]
    \  ${Index} =  Evaluate  ${Index}+1
    Append To List  ${BandwidthList}  @{TestList}[${List_Length-1}]
    Log List  ${BandwidthList}

    ${Summary} =  Convert To String  @{TestList}[${List_Length-1}]
    ${Summary} =  Remove String  ${Summary}  ${Junk}
    ${Summary} =  Replace String  ${Summary}  3]  128Bytes${SPACE}
    ${Summary} =  Remove String  ${Summary}  [
    ${Summary} =  Strip String  ${Summary}

    ${Status} =  Split String  ${Summary}  ms
    ${Status} =  Get From List  ${Status}  1

    ${Status} =  Split String  ${Status}  /
    ${Status} =  Get From List  ${Status}  0
    ${Status} =  Convert To String  ${Status}
    ${Status} =  Strip String  ${Status}
    ${Result} =  Set Variable If  ${Status} == 0  Pass  Fail
    ${Summary} =  Set Variable  ${Summary}${SPACE}${SPACE}${SPACE}${Result}

    Append To List  ${BandwidthList}  ${Summary}
    Log List  ${BandwidthList}
    Remove From List  ${BandwidthList}  2

Bandwidth Test 256
    ${Traffic_Server} =  Open Connection  ${Server_IP}
    Login  ${Server_User}  ${Server_Pwd}
    Start Command  iperf -s -u
    Sleep  1s
    ${Traffic_Client} =  Open Connection  ${Client_IP}  prompt=>
    Login  ${Client_User}  ${Client_Pwd}
    Start Command  iperf -c ${Server_IP} -i 10 -b 25Mb -u -w 256 -t 2
    Sleep  3s
    ${TCP_Client} =  Read Command Output
    @{TestList} =  Split To Lines  ${TCP_Client}
    ${List_Length} =  Get Length  ${TestList}
    Append To File  ${Path}/Result.txt  ${\n}${\n}****Results for 256 byte Size with rate 25 Mbps****${\n}
    Append To File  ${Path}/Result.txt  ${\n}@{TestList}[0]
    :FOR  ${Index}  IN RANGE  1  ${List_Length}
    \  Append To File  ${Path}/Result.txt  ${\n}@{TestList}[${Index}]
    \  ${Index} =  Evaluate  ${Index}+1
    Append To List  ${BandwidthList}  @{TestList}[${List_Length-1}]
    Log List  ${BandwidthList}

    ${Summary} =  Convert To String  @{TestList}[${List_Length-1}]
    ${Summary} =  Remove String  ${Summary}  ${Junk}
    ${Summary} =  Replace String  ${Summary}  3]  256Bytes${SPACE}
    ${Summary} =  Remove String  ${Summary}  [
    ${Summary} =  Strip String  ${Summary}

    ${Status} =  Split String  ${Summary}  ms
    ${Status} =  Get From List  ${Status}  1

    ${Status} =  Split String  ${Status}  /
    ${Status} =  Get From List  ${Status}  0
    ${Status} =  Convert To String  ${Status}
    ${Status} =  Strip String  ${Status}
    ${Result} =  Set Variable If  ${Status} == 0  Pass  Fail
    ${Summary} =  Set Variable  ${Summary}${SPACE}${SPACE}${SPACE}${Result}

    Remove From List  ${BandwidthList}  3
    Append To List  ${BandwidthList}  ${Summary}
    Log List  ${BandwidthList}

Bandwidth Test 512
    ${Traffic_Server} =  Open Connection  ${Server_IP}
    Login  ${Server_User}  ${Server_Pwd}
    Start Command  iperf -s -u
    Sleep  1s
    ${Traffic_Client} =  Open Connection  ${Client_IP}  prompt=>
    Login  ${Client_User}  ${Client_Pwd}
    Start Command  iperf -c ${Server_IP} -i 10 -b 25Mb -u -w 512 -t 2
    Sleep  3s
    ${TCP_Client} =  Read Command Output
    @{TestList} =  Split To Lines  ${TCP_Client}
    ${List_Length} =  Get Length  ${TestList}
    Append To File  ${Path}/Result.txt  ${\n}${\n}****Results for 512 byte Size with rate 25 Mbps****${\n}
    Append To File  ${Path}/Result.txt  ${\n}@{TestList}[0]
    :FOR  ${Index}  IN RANGE  1  ${List_Length}
    \  Append To File  ${Path}/Result.txt  ${\n}@{TestList}[${Index}]
    \  ${Index} =  Evaluate  ${Index}+1
    Append To List  ${BandwidthList}  @{TestList}[${List_Length-1}]
    Log List  ${BandwidthList}

    ${Summary} =  Convert To String  @{TestList}[${List_Length-1}]
    ${Summary} =  Remove String  ${Summary}  ${Junk}
    ${Summary} =  Replace String  ${Summary}  3]  512Bytes${SPACE}
    ${Summary} =  Remove String  ${Summary}  [
    ${Summary} =  Strip String  ${Summary}

    ${Status} =  Split String  ${Summary}  ms
    ${Status} =  Get From List  ${Status}  1

    ${Status} =  Split String  ${Status}  /
    ${Status} =  Get From List  ${Status}  0
    ${Status} =  Convert To String  ${Status}
    ${Status} =  Strip String  ${Status}
    ${Result} =  Set Variable If  ${Status} == 0  Pass  Fail
    ${Summary} =  Set Variable  ${Summary}${SPACE}${SPACE}${SPACE}${Result}

    Remove From List  ${BandwidthList}  4
    Append To List  ${BandwidthList}  ${Summary}
    Log List  ${BandwidthList}

Bandwidth Test 1024
    ${Traffic_Server} =  Open Connection  ${Server_IP}
    Login  ${Server_User}  ${Server_Pwd}
    Start Command  iperf -s -u
    Sleep  1s
    ${Traffic_Client} =  Open Connection  ${Client_IP}  prompt=>
    Login  ${Client_User}  ${Client_Pwd}
    Start Command  iperf -c ${Server_IP} -i 10 -b 25Mb -u -w 1024 -t 2
    Sleep  3s
    ${TCP_Client} =  Read Command Output
    @{TestList} =  Split To Lines  ${TCP_Client}
    ${List_Length} =  Get Length  ${TestList}
    Append To File  ${Path}/Result.txt  ${\n}${\n}****Results for 1024 byte Size with rate 25 Mbps****${\n}
    Append To File  ${Path}/Result.txt  ${\n}@{TestList}[0]
    :FOR  ${Index}  IN RANGE  1  ${List_Length}
    \  Append To File  ${Path}/Result.txt  ${\n}@{TestList}[${Index}]
    \  ${Index} =  Evaluate  ${Index}+1
    Append To List  ${BandwidthList}  @{TestList}[${List_Length-1}]
    Log List  ${BandwidthList}

    ${Summary} =  Convert To String  @{TestList}[${List_Length-1}]
    ${Summary} =  Remove String  ${Summary}  ${Junk}
    ${Summary} =  Replace String  ${Summary}  3]  1024Bytes
    ${Summary} =  Remove String  ${Summary}  [
    ${Summary} =  Strip String  ${Summary}

    ${Status} =  Split String  ${Summary}  ms
    ${Status} =  Get From List  ${Status}  1

    ${Status} =  Split String  ${Status}  /
    ${Status} =  Get From List  ${Status}  0
    ${Status} =  Convert To String  ${Status}
    ${Status} =  Strip String  ${Status}
    ${Result} =  Set Variable If  ${Status} == 0  Pass  Fail
    ${Summary} =  Set Variable  ${Summary}${SPACE}${SPACE}${SPACE}${Result}

    Remove From List  ${BandwidthList}  5
    Append To List  ${BandwidthList}  ${Summary}
    Log List  ${BandwidthList}


Bandwidth Test 1280
    ${Traffic_Server} =  Open Connection  ${Server_IP}
    Login  ${Server_User}  ${Server_Pwd}
    Start Command  iperf -s -u
    Sleep  1s
    ${Traffic_Client} =  Open Connection  ${Client_IP}  prompt=>
    Login  ${Client_User}  ${Client_Pwd}
    Start Command  iperf -c ${Server_IP} -i 10 -b 25Mb -u -w 1280 -t 2
    Sleep  3s
    ${TCP_Client} =  Read Command Output
    @{TestList} =  Split To Lines  ${TCP_Client}
    ${List_Length} =  Get Length  ${TestList}
    Append To File  ${Path}/Result.txt  ${\n}${\n}****Results for 1280 byte Size with rate 25 Mbps****${\n}
    Append To File  ${Path}/Result.txt  ${\n}@{TestList}[0]
    :FOR  ${Index}  IN RANGE  1  ${List_Length}
    \  Append To File  ${Path}/Result.txt  ${\n}@{TestList}[${Index}]
    \  ${Index} =  Evaluate  ${Index}+1
    Append To List  ${BandwidthList}  @{TestList}[${List_Length-1}]
    Log List  ${BandwidthList}

    ${Summary} =  Convert To String  @{TestList}[${List_Length-1}]
    ${Summary} =  Remove String  ${Summary}  ${Junk}
    ${Summary} =  Replace String  ${Summary}  3]  1280Bytes
    ${Summary} =  Remove String  ${Summary}  [
    ${Summary} =  Strip String  ${Summary}

    ${Status} =  Split String  ${Summary}  ms
    ${Status} =  Get From List  ${Status}  1

    ${Status} =  Split String  ${Status}  /
    ${Status} =  Get From List  ${Status}  0
    ${Status} =  Convert To String  ${Status}
    ${Status} =  Strip String  ${Status}
    ${Result} =  Set Variable If  ${Status} == 0  Pass  Fail
    ${Summary} =  Set Variable  ${Summary}${SPACE}${SPACE}${SPACE}${Result}

    Remove From List  ${BandwidthList}  6
    Append To List  ${BandwidthList}  ${Summary}
    Log List  ${BandwidthList}

Bandwidth Test 1518
    ${Traffic_Server} =  Open Connection  ${Server_IP}
    Login  ${Server_User}  ${Server_Pwd}
    Start Command  iperf -s -u
    Sleep  1s
    ${Traffic_Client} =  Open Connection  ${Client_IP}  prompt=>
    Login  ${Client_User}  ${Client_Pwd}
    Start Command  iperf -c ${Server_IP} -i 10 -b 25Mb -u -w 1518 -t 2
    Sleep  3s
    ${TCP_Client} =  Read Command Output
    @{TestList} =  Split To Lines  ${TCP_Client}
    ${List_Length} =  Get Length  ${TestList}
    Append To File  ${Path}/Result.txt  ${\n}${\n}****Results for 1518 byte Size with rate 25 Mbps****${\n}
    Append To File  ${Path}/Result.txt  ${\n}@{TestList}[0]
    :FOR  ${Index}  IN RANGE  1  ${List_Length}
    \  Append To File  ${Path}/Result.txt  ${\n}@{TestList}[${Index}]
    \  ${Index} =  Evaluate  ${Index}+1
    Append To List  ${BandwidthList}  @{TestList}[${List_Length-1}]
    Log List  ${BandwidthList}

    ${Summary} =  Convert To String  @{TestList}[${List_Length-1}]
    ${Summary} =  Remove String  ${Summary}  ${Junk}
    ${Summary} =  Replace String  ${Summary}  3]  1518Bytes
    ${Summary} =  Remove String  ${Summary}  [
    ${Summary} =  Strip String  ${Summary}

    ${Status} =  Split String  ${Summary}  ms
    ${Status} =  Get From List  ${Status}  1

    ${Status} =  Split String  ${Status}  /
    ${Status} =  Get From List  ${Status}  0
    ${Status} =  Convert To String  ${Status}
    ${Status} =  Strip String  ${Status}
    ${Result} =  Set Variable If  ${Status} == 0  Pass  Fail
    ${Summary} =  Set Variable  ${Summary}${SPACE}${SPACE}${SPACE}${Result}

    Remove From List  ${BandwidthList}  7
    Append To List  ${BandwidthList}  ${Summary}

    Log List  ${BandwidthList}