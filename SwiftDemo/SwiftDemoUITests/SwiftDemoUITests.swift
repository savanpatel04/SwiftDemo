import XCTest

final class SwiftDemoUITests: XCTestCase {

    func testSearchCharacters() {
        let app = XCUIApplication()
        app.launch()

        let searchField = app.textFields["Search characters"]

        XCTAssertTrue(searchField.exists)

        searchField.tap()
        searchField.typeText("Rick")

        let rick = app.staticTexts["Rick Sanchez"]

        rick.tap()


        XCTAssertTrue(
            app.navigationBars["Rick Sanchez"].waitForExistence(timeout: 5)
        )
    }
    
    func testCharacterDetail() {
        let app = XCUIApplication()
        app.launch()

        let searchField = app.textFields["Search characters"]

        searchField.tap()
        searchField.typeText("Rick")

        let rick = app.staticTexts["Rick Sanchez"]

        XCTAssertTrue(
            rick.waitForExistence(timeout: 5)
        )

        rick.tap()

        XCTAssertTrue(
            app.navigationBars["Rick Sanchez"].waitForExistence(timeout: 5)
        )

        XCTAssertTrue(app.staticTexts["Species"].exists)
        XCTAssertTrue(app.staticTexts["Human"].exists)

        XCTAssertTrue(app.staticTexts["Status"].exists)
        XCTAssertTrue(app.staticTexts["Alive"].exists)

        XCTAssertTrue(app.staticTexts["Origin"].exists)
        XCTAssertTrue(app.staticTexts["Earth (C-137)"].exists)

        XCTAssertTrue(app.staticTexts["Created"].exists)
    }
}
