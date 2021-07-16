*** Settings ***
Library     AppiumLibrary
Resource    Resources/android-res.robot

*** Test Cases ***
Login
    set appium timeout      10s
    Open Chat21 Application On First Device
    Signin With User    ${USER1-DETAILS}[email]     ${USER1-DETAILS}[password]
    Go To Chat Tab
    Go to Profile Page
    set appium timeout      3s
    Click The Logout Button
