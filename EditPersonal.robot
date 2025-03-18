*** Settings ***
Library           SeleniumLibrary

*** Variables ***
${URL}                  https://impl.wd12.myworkday.com/wday/authgwy/wyndenstark_dpt1/login.htmld 
${BROWSER}              chrome
${USERNAME_FIELD}       xpath://input[@aria-label='Username']
${PASSWORD_FIELD}       xpath://input[@aria-label='Password']
${SEARCH_INPUT}         xpath://input[@data-automation-id="globalSearchInput"]
${EDIT_PERSONAL_INFO}   xpath://a[text()='Edit Personal Information']
${POPUP_PERSON_FIELD}   xpath://div[@data-automation-widget="wd-popup"]//input[@placeholder='Search']
${PERSON_OPTION}        xpath://div[contains(@data-automation-id, 'promptOption') and contains(text(), '${PERSON_NAME}')]
${OK_BUTTON}            xpath://button[@data-automation-id="wd-CommandButton_uic_okButton" and @title="OK"]
${PERSON_NAME}          Ben Adams
${COMMENT_BOX}          xpath://textarea[@data-automation-id="textAreaField"]
${SUBMIT_BUTTON}        xpath://button[contains(@title, 'Submit')]
${VIEW_DETAILS_BUTTON}  xpath://button[@data-uxi-button-type='view-detail' and contains(@class, 'ViewDetailsButton')]

*** Test Cases ***
Login and Edit Personal Information
    Open Browser And Login
    Open Search Tab And Enter Query
    Select Edit Personal Information From Search Results
    Handle Edit Personal Information Popup    ${PERSON_NAME}
    Click OK Button to Proceed
    Scroll Down to Comment Section and Submit
    Wait After Entering Comment
    Scroll To Bottom Before Submit
    Click Submit Button to Complete Action
    Click View Details After Submission
    Gracefully Close Browser

*** Keywords ***
Open Browser And Login
    [Documentation]  Open the browser, navigate to the URL, and log in.
    Open Browser                       ${URL}              ${BROWSER}
    Maximize Browser Window
    Wait Until Element Is Visible      ${USERNAME_FIELD}   timeout=10s
    Input Text                         ${USERNAME_FIELD}   lmcneil
    Input Password                     ${PASSWORD_FIELD}   Theakitt777!
    Press Keys                         ${PASSWORD_FIELD}   RETURN
    Wait Until Element Is Visible      ${SEARCH_INPUT}     timeout=30s
    
    # Capture screenshot after login.
    Capture Page Screenshot            Login_Screenshot.png

Open Search Tab And Enter Query
    [Documentation]  Locate the global search input field and enter a query.
    Wait Until Keyword Succeeds        3x                  5s
    ...                                Locate And Interact With Search Input
    
Locate And Interact With Search Input
    Wait Until Element Is Visible      ${SEARCH_INPUT}     timeout=10s
    Scroll Element Into View           ${SEARCH_INPUT}
    Wait Until Element Is Enabled      ${SEARCH_INPUT}
    Clear Element Text                 ${SEARCH_INPUT}
    Input Text                         ${SEARCH_INPUT}     Edit Personal Information
    Press Keys                         ${SEARCH_INPUT}     RETURN
    
    # Capture screenshot after entering search query.
    Capture Page Screenshot            Search_Query_Screenshot.png

Select Edit Personal Information From Search Results
    [Documentation]  Select the "Edit Personal Information" option from search results.
    Wait Until Element Is Visible      ${EDIT_PERSONAL_INFO}   timeout=10s
    Click Element                      ${EDIT_PERSONAL_INFO}
    
    # Capture screenshot after selecting "Edit Personal Information."
    Capture Page Screenshot            Select_Edit_Personal_Info_Screenshot.png

Handle Edit Personal Information Popup
    [Arguments]                        ${person_name}
    
    [Documentation]  Handle the popup modal to select a person by name.
    
    # Ensure popup is visible.
    Wait Until Element Is Visible      xpath://div[@data-automation-widget="wd-popup"]   timeout=10s
    
    # Locate the Person field inside the popup modal.
    Wait Until Element Is Visible      ${POPUP_PERSON_FIELD}   timeout=10s
    
    # Clear any existing text and input the person's name.
    Clear Element Text                 ${POPUP_PERSON_FIELD}
    
    # Input the person's name into the popup search bar.
    Input Text                         ${POPUP_PERSON_FIELD}   ${person_name}
    
    # Simulate pressing Enter key to confirm.
    Press Keys                         ${POPUP_PERSON_FIELD}   RETURN    
    
    # Pause for stability to ensure the person is selected.
    Sleep                              5s
    
    # Capture screenshot after handling popup.
    Capture Page Screenshot            Handle_Popup_Screenshot.png

Click OK Button to Proceed
    [Documentation]  Click the "OK" button to proceed after handling the popup modal.
    
    # Ensure the button is visible and interactable.
    Wait Until Page Contains Element   ${OK_BUTTON}        timeout=10s
    
    # Scroll to the button if necessary.
    Scroll Element Into View           ${OK_BUTTON}
    
    # Attempt to click the button using Selenium's Click Button keyword.
    Click Button                       ${OK_BUTTON}

Scroll Down to Comment Section and Submit
     [Documentation]  Scroll down to locate the comment section, enter a comment, and submit it.

     # Ensure dynamic content loads properly.
     Sleep                              3s

     # Ensure the comment box is visible.
     Wait Until Element Is Visible      ${COMMENT_BOX}      timeout=10s

     # Scroll down to ensure visibility of the comment box.
     Scroll Element Into View           ${COMMENT_BOX}

     # Enter "TEST" into the comment box.
     Input Text                         ${COMMENT_BOX}      TEST

Wait After Entering Comment
     [Documentation]  Add a wait time after entering a comment for stability.
     
     Sleep                             3s  # Adjust time as needed

Scroll To Bottom Before Submit
     [Documentation]  Scroll to the bottom of the page before interacting with the submit button.

     Execute Javascript                window.scrollTo(0, document.body.scrollHeight);
     Sleep                             3s  # Allow time for any dynamic content to load

Click Submit Button to Complete Action
     [Documentation]  Locate and click the Submit button successfully.
     
     # Ensure the Submit button is visible and interactable.
     Wait Until Page Contains Element  ${SUBMIT_BUTTON}     timeout=10s

     # Attempt to click the Submit button using Selenium's Click Button keyword.
     Click Button                      ${SUBMIT_BUTTON}

Click View Details After Submission
     [Documentation]  Locate and click on the "View Details" button to view submission details.

     Wait Until Element Is Visible      ${VIEW_DETAILS_BUTTON}   timeout=10s

     Click Button                       ${VIEW_DETAILS_BUTTON}

     # Pause for stability after clicking "View Details."
     Sleep                             3s
    
     # Capture screenshot after clicking "View Details."
     Capture Page Screenshot            View_Details_Screenshot.png

Gracefully Close Browser
     Close All Browsers
