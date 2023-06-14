import XCTest
import Validation

final class EmailValidatorAdapterTests: XCTestCase {

    func test_invalid_emails() {
        let sut = makeSUT()
        XCTAssertFalse(sut.isValid(email: "aa"))
        XCTAssertFalse(sut.isValid(email: "a@"))
        XCTAssertFalse(sut.isValid(email: "a@a"))
        XCTAssertFalse(sut.isValid(email: "a@a."))
        XCTAssertFalse(sut.isValid(email: "@a.com"))
    }

    func test_valid_emails() {
        let sut = makeSUT()
        XCTAssertTrue(sut.isValid(email: "diego@gmail.com"))
        XCTAssertTrue(sut.isValid(email: "diego@hotmail.com"))
        XCTAssertTrue(sut.isValid(email: "diego@hotmail.com.br"))
    }
}

extension EmailValidatorAdapterTests {

    private func makeSUT() -> EmailValidatorAdapter { EmailValidatorAdapter() }
}
