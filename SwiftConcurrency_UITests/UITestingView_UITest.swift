//
//  UITestingView_UITest.swift
//  SwiftConcurrency_UITests
//
//  Created by Artem Golovchenko on 2025-05-11.
//

import XCTest

final class UITestingView_UITest: XCTestCase {
    
    let app = XCUIApplication()

    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()

    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_UITestingView_SignUpButton_ShouldNotSignIn() {
        signUpAndSignIn(shouldTypeOnKeyboard: false)
        
        let navbar = app.navigationBars["Welcome"]
        //Then
        
        XCTAssertFalse(navbar.exists)
    }
    
    func test_UITestingView_SignUpButton_ShouldSignIn() {
        signUpAndSignIn(shouldTypeOnKeyboard: true)
        
        let navbar = app.navigationBars["Welcome"]
        //Then
        
        XCTAssert(navbar.exists)
    }
    
    func test_SignInHomeView_ShowAlertButton_ShouldShowAlert() {
        signUpAndSignIn(shouldTypeOnKeyboard: true)

        app.buttons["ShowAlertButton"].tap()
        
        let alert = app.alerts["Welcome"] // app.alerts.firstMatch
        XCTAssert(alert.exists)
    }
    
    func test_SignInHomeView_ShowAlertButton_ShouldShowAndDismissAlert() {
        signUpAndSignIn(shouldTypeOnKeyboard: true)
        app.buttons["ShowAlertButton"].tap()
        
        let alert = app.alerts["Welcome"] // app.alerts.firstMatch
        XCTAssert(alert.exists)
        
        let alertOKButton = alert.buttons["OK"]
        sleep(1)
        alertOKButton.tap()
        sleep(1)
        //Then
        XCTAssertFalse(alert.exists)
    }
    
    func test_SignInHomeView_NavigationToDestination_ShouldNavigateToDestination() {
        signUpAndSignIn(shouldTypeOnKeyboard: true)
        
        app.buttons["NavlinkToDestination"].tap()
        
        let destText = app/*@START_MENU_TOKEN@*/.staticTexts["Destination"]/*[[".otherElements.staticTexts[\"Destination\"]",".staticTexts.firstMatch",".staticTexts[\"Destination\"]"],[[[-1,2],[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        XCTAssert(destText.exists)
    }
    
    func test_SignInHomeView_NavigationToDestination_ShouldNavigateToDestinationAndComeBack() {
        signUpAndSignIn(shouldTypeOnKeyboard: true)
        
        app.buttons["NavlinkToDestination"].tap()
        
        let destText = app/*@START_MENU_TOKEN@*/.staticTexts["Destination"]/*[[".otherElements.staticTexts[\"Destination\"]",".staticTexts.firstMatch",".staticTexts[\"Destination\"]"],[[[-1,2],[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        XCTAssert(destText.exists)
        
        let backButton = app/*@START_MENU_TOKEN@*/.buttons["Welcome"]/*[[".navigationBars.buttons[\"Welcome\"]",".buttons.firstMatch",".buttons[\"Welcome\"]"],[[[-1,2],[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        backButton.tap()
    
        let navbar = app.navigationBars["Welcome"]
        //Then
        
        XCTAssert(navbar.exists)
    }

}

extension UITestingView_UITest {
    func signUpAndSignIn(shouldTypeOnKeyboard: Bool) {
        //Given
        let textfield = app.textFields["Sign Up TextField"]
        
        //When
        textfield.tap()
        
        if shouldTypeOnKeyboard {
            let AKey = app.keys["A"]
            AKey.tap()
            
            let aKey = app.keys["a"]
            aKey.tap()
            aKey.tap()
            aKey.tap()
            app.keys["s"].tap()
        }

        app.buttons["Return"].tap()
        
        app.buttons["SignUpButton"].tap()
    }
}
