import XCTest
import Presentation

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

public final class EmailValidatorAdapter: EmailValidator {
    private let pattern = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"

    public func isValid(email: String) -> Bool {
        let range = NSRange(location: 0, length: email.utf16.count)
        let regex = try! NSRegularExpression(pattern: pattern)
        return regex.firstMatch(in: email, range: range) != nil
    }
}
