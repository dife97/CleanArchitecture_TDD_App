import XCTest
import UI
import Main

final class SignUpComposerTests: XCTestCase {

    func test_background_request_shoud_complete_on_main_thread() {
        let (sut, _) = makeSUT()
//        DispatchQueue.global().async {
//            addAccountSpy.completeWithError(.unexpected)
//        }
        sut.loadViewIfNeeded()
    }
}

extension SignUpComposerTests {

    private func makeSUT(
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> (SignUpViewController, AddAccountSpy) {
        let addAccountSpy = AddAccountSpy()
        let sut = SignUpComposer.composeController(with: addAccountSpy)

        checkMemoryLeak(for: sut, file: file, line: line)

        return (sut, addAccountSpy)
    }
}
