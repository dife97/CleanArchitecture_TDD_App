import XCTest
import Main

final class SignUpComposerTests: XCTestCase {

    func test_UI_presentation_integration() {
        let sut = SignUpComposer.composeController(with: AddAccountSpy())
        checkMemoryLeak(for: sut)
    }
}
