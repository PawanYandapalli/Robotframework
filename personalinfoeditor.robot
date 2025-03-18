*** Settings ***
Library           SeleniumLibrary

*** Variables ***
${URL}                  https://impl.wd12.myworkday.com/lrb_dpt1/login.htmld
${BROWSER}              chrome
${USERNAME_FIELD}       xpath://input[@aria-label='Username']
${PASSWORD_FIELD}       xpath://input[@aria-label='Password']
${SEARCH_INPUT}         xpath://input[@data-automation-id="globalSearchInput"]
${EDIT_PERSONAL_INFO}   xpath://div[contains(text(), 'Edit Personal Information')]
${POPUP_PERSON_FIELD}   xpath://div[@data-automation-widget="wd-popup"]//input[@placeholder='Search']
${PERSON_OPTION}        xpath://div[contains(@data-automation-id, 'promptOption') and contains(text(), '${PERSON_NAME}')]
${OK_BUTTON}            xpath://button[@data-automation-id="wd-CommandButton_uic_okButton" and @title="OK"]
${PERSON_NAME}          Ben Adams
${COMMENT_BOX}          xpath://textarea[@role='textbox' and @data-automation-id='textAreaField']
${SUBMIT_BUTTON}        xpath://button[contains(@title, 'Submit')]

*** Test Cases ***
Login and Edit Personal Information
    Open Browser And Login
    Open Search Tab And Enter Query
    Select Edit Personal Information From Search Results
    Handle Edit Personal Information Popup    ${PERSON_NAME}
    Click OK Button to Proceed
    Scroll Down to Comment Section and Submit
    Scroll To Bottom Before Submit
    Click Submit Button to Complete Action
    Wait For Page Load After Submit
    Open successfully logged in page

*** Keywords ***
Open Browser And Login
    Open Browser                       ${URL}              ${BROWSER}
    Maximize Browser Window
    Wait Until Element Is Visible      ${USERNAME_FIELD}   timeout=20s
    Input Text                         ${USERNAME_FIELD}   lmcneil
    Input Password                     ${PASSWORD_FIELD}   Win@2024$
    Press Keys                         ${PASSWORD_FIELD}   RETURN
    Wait Until Element Is Visible      ${SEARCH_INPUT}     timeout=5s
    
    # Capture screenshot after login.
    Capture Page Screenshot            Login_Screenshot.png

Open Search Tab And Enter Query
    Wait Until Keyword Succeeds        3x                  5s
    ...                                Locate And Interact With Search Input
    
Locate And Interact With Search Input
    Wait Until Element Is Visible      ${SEARCH_INPUT}     timeout=5s
    Scroll Element Into View           ${SEARCH_INPUT}
    Wait Until Element Is Enabled      ${SEARCH_INPUT}
    Clear Element Text                 ${SEARCH_INPUT}
    Input Text                         ${SEARCH_INPUT}     Edit Personal Information
    Press Keys                         ${SEARCH_INPUT}     RETURN
    
    # Capture screenshot after entering search query.
    Capture Page Screenshot            Search_Query_Screenshot.png

Select Edit Personal Information From Search Results
    Wait Until Element Is Visible      ${EDIT_PERSONAL_INFO}   timeout=5s
    Click Element                      ${EDIT_PERSONAL_INFO}
    
    # Capture screenshot after selecting "Edit Personal Information."
    Capture Page Screenshot            Select_Edit_Personal_Info_Screenshot.png

Handle Edit Personal Information Popup
    [Arguments]                        ${person_name}
    
    # Ensure popup is visible.
    Wait Until Element Is Visible      xpath://div[@data-automation-widget="wd-popup"]   timeout=5s
    
    # Locate the Person field inside the popup modal.
    Wait Until Element Is Visible      ${POPUP_PERSON_FIELD}   timeout=5s
    
    # Clear any existing text and input "Ben Adams."
    Clear Element Text                 ${POPUP_PERSON_FIELD}
    
    # Input "Ben Adams" into the popup search bar.
    Input Text                         ${POPUP_PERSON_FIELD}   ${person_name}
    
    # Simulate pressing Enter key to confirm.
    Press Keys                         ${POPUP_PERSON_FIELD}   RETURN    
    
    # Capture screenshot after handling popup.
    Capture Page Screenshot            Handle_Popup_Screenshot.png

Click OK Button to Proceed
    # Ensure the button is visible and interactable.
    Wait Until Page Contains Element   ${OK_BUTTON}        timeout=5s
    
    # Scroll to the button if necessary.
    Scroll Element Into View           ${OK_BUTTON}
    
    # Attempt to click the button using Selenium's Click Button keyword.
    Click Button                       ${OK_BUTTON}
    
    # Capture screenshot after clicking OK button.
    Capture Page Screenshot            Click_OK_Button_Screenshot.png

Scroll Down to Comment Section and Submit
    [Documentation]                    Scroll down to locate the comment section, enter a comment, and submit it.
    
    # Scroll down to ensure the comment box is visible.
    Scroll Element Into View           ${COMMENT_BOX}
    
    # Scroll to the bottom of the page before interacting with the submit button.
    Scroll To Bottom Before Submit
    
    # Wait until the comment box is interactable.
    Wait Until Element Is Visible      ${COMMENT_BOX}      timeout=5s
    
    # Enter "TEST" into the comment box.
    Input Text                         ${COMMENT_BOX}      TEST

Scroll To Bottom Before Submit
     [Documentation]                   Scroll to the bottom of the page before interacting with the submit button.

     Execute Javascript                window.scrollTo(0, document.body.scrollHeight);
     Sleep                             3s  # Allow time for any dynamic content to load

Click Submit Button to Complete Action
     [Documentation]                   Locate and click the Submit button successfully.
     
     # Ensure the Submit button is visible and interactable.
     Wait Until Page Contains Element  ${SUBMIT_BUTTON}     timeout=5s

     # Attempt to click the Submit button using Selenium's Click Button keyword.
     Click Button                      ${SUBMIT_BUTTON}
     
     # Capture screenshot after submitting changes.
     Capture Page Screenshot           Submit_Changes_Screenshot.png

Wait For Page Load After Submit
     [Documentation]                   Allow time for page loading after submitting changes.

     Sleep                             5s  # Adjust time based on expected load duration.

Gracefully Close Browser
     Close All Browsers
     
