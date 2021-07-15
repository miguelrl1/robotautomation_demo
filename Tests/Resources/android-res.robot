*** Settings ***
Library     AppiumLibrary
Resource    password.robot

*** Variables ***
#*** Test Variables ***
&{USER1-DETAILS}        email=test1@robot.com.mx        password=${PASSWORD}        name=Test1 Test1
&{USER2-DETAILS}        email=test2@robot.com.mx        password=${PASSWORD}        name=Test2 Test2
${APPIUM-PORT-DEVICE1}      4723
#*** Android 10 variables ***
${ANDROID10-CONTINUE-BUTTON}        id=com.android.permissioncontroller:id/continue_button
${ANDROID10-OK-BUTTON}              //android.widget.Button[@text="OK"]

#*** Application Variables ***
${CHAT21-APPLICATION-ID}          chat21.android.demo
${CHAT21-APPLICATION-ACTIVITY}    chat21.android.demo.SplashActivity
#*** Login Page ***
${LOGIN-EMAIL-FIELD}        id=${CHAT21-APPLICATION-ID}:id/email
${LOGIN-PASSWORD-FIELD}     id=${CHAT21-APPLICATION-ID}:id/password
${LOGIN-SIGNIN-BUTTON}      id=${CHAT21-APPLICATION-ID}:id/login
#*** Main Page ***
${MAIN-HOME-TAB}            //android.widget.TextView[@text="HOME"]
${MAIN-PROFILE-TAB}         //android.widget.TextView[@text="PROFILE"]
${MAIN-CHAT-TAB}            //android.widget.TextView[@text="CHAT"]
#*** Profile Page ***
${PROFILE-LOGOUT-BUTTON}    id=${CHAT21-APPLICATION-ID}:id/logout

#*** Chat Tab ***
${CHAT-NEW-CONVERSATION-BUTTON}     id=${CHAT21-APPLICATION-ID}:id/button_new_conversation
${NEW_CONVERSATION_CONTACTS_HEADER}     //android.view.ViewGroup[contains(@resource-id, 'toolbar')]//android.widget.TextView[@text="Contacts"]
${NEW_CONVERSATION_CONTACTS_HEADER-SEARCH-BUTTON}     id=${CHAT21-APPLICATION-ID}:id/action_search
${NEW_CONVERSATION_CONTACTS_HEADER-SEARCH-FIELD}     id=${CHAT21-APPLICATION-ID}:id/search_src_text

#*** Conversation Window ***
${CONVERSATION-INPUT-FILED}              id=${CHAT21-APPLICATION-ID}:id/main_activity_chat_bottom_message_edittext
${CONVERSATION-SEND-MESSAGE-BUTTON}     id=${CHAT21-APPLICATION-ID}:id/main_activity_send

*** Keywords ***

Open Chat21 Application
    [Arguments]     ${APPIUM-PORT}=${APPIUM-PORT-DEVICE1}
    Open Application        http://192.168.49.1:${APPIUM-PORT}/wd/hub    platformName=Android    appPackage=${CHAT21-APPLICATION-ID}      appActivity=${CHAT21-APPLICATION-ACTIVITY}    automationName=Uiautomator2
    ${ALERT}        run keyword and return status       page should not contain element     ${ANDROID10-CONTINUE-BUTTON}
    run keyword if      '${ALERT}' == 'False'     Bypass Android 10 Alerts

Open Chat21 Application On First Device
    Open Chat21 Application     ${APPIUM-PORT-DEVICE1}

Bypass Android 10 Alerts
    wait until page contains element    ${ANDROID10-CONTINUE-BUTTON}
    click element                       ${ANDROID10-CONTINUE-BUTTON}
    wait until page contains element    ${ANDROID10-OK-BUTTON}
    click element                       ${ANDROID10-OK-BUTTON}

Signin With User
    [Arguments]     ${EMAIL}    ${USERPASSWORD}
    Input User Email        ${EMAIL}
    Input User Password     ${USERPASSWORD}
    Submit Login
    Verify Login Is Successful

Input User Email
    [Arguments]     ${EMAIL}
    Verify Login Email Field Is Displayed
    input text      ${LOGIN-EMAIL-FIELD}        ${EMAIL}

Input User Password
    [Arguments]     ${USERPASSWORD}
    input text      ${LOGIN-PASSWORD-FIELD}     ${USERPASSWORD}

Submit Login
     click element                      ${LOGIN-SIGNIN-BUTTON}

Verify Login Is Successful
    wait until page contains element    ${MAIN-HOME-TAB}

Logout With User
    Go to Profile Page
    Click The Logout Button
    Verify Login Email Field Is Displayed

Go to Profile Page
    click element                       ${MAIN-PROFILE-TAB}
    wait until page contains element    ${PROFILE-LOGOUT-BUTTON}

Click The Logout Button
    click element                       ${PROFILE-LOGOUT-BUTTON}

Verify Login Email Field Is Displayed
    wait until page contains element    ${LOGIN-EMAIL-FIELD}

Go To Chat Tab
    click element   ${MAIN-CHAT-TAB}
    wait until page contains element    ${CHAT-NEW-CONVERSATION-BUTTON}

#*** Chat Tab
Create New Conversation
    [Arguments]     ${NAME}
    click element   ${CHAT-NEW-CONVERSATION-BUTTON}
    wait until page contains element  ${NEW_CONVERSATION_CONTACTS_HEADER-SEARCH-BUTTON}
    Search For Contact      ${NAME}
    click element   //android.widget.TextView[contains(@resource-id, 'fullname') and @text="${NAME}"]
    Wait Until Conversation Window Is Open      ${NAME}

Search For Contact
    [Arguments]     ${NAME}
    Sleep  5s
    click element                       ${NEW_CONVERSATION_CONTACTS_HEADER-SEARCH-BUTTON}
    wait until page contains element    ${NEW_CONVERSATION_CONTACTS_HEADER-SEARCH-FIELD}
    Sleep  30s
    input text                          ${NEW_CONVERSATION_CONTACTS_HEADER-SEARCH-FIELD}    ${NAME}
    wait until page contains element   //android.widget.TextView[contains(@resource-id, 'fullname') and @text="${NAME}"]

Wait Until Page Contains Conversation
    [Arguments]     ${NAME}
    wait until page contains element  //android.widget.TextView[contains(@resource-id, 'recipient_display_name') and @text="${NAME}"]

Open Conversation
    [Arguments]     ${NAME}
    wait until page contains conversation   ${NAME}
    click element   //android.widget.TextView[contains(@resource-id, 'recipient_display_name') and @text="${NAME}"]

Wait Until Conversation Window Is Open
    [Arguments]     ${NAME}
    wait until page contains element  //android.widget.TextView[contains(@resource-id, 'toolbar') and @text="${NAME}"]

Send Message Inside Conversation Window
    [Arguments]     ${MESSAGE}
    wait until page contains element    ${CONVERSATION-INPUT-FILED}
    input text     ${CONVERSATION-INPUT-FILED}      ${MESSAGE}
    click element  ${CONVERSATION-SEND-MESSAGE-BUTTON}
    Wait Until Conversation Contains Message    ${MESSAGE}

Wait Until Conversation Contains Message
    [Arguments]     ${MESSAGE}
    wait until page contains element    //android.widget.TextView[contains(@resource-id, 'message') and @text="${MESSAGE}"]
