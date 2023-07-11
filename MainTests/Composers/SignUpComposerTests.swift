import XCTest
import UI
import Main

final class SignUpComposerTests: XCTestCase {

    func test_background_request_shoud_complete_on_main_thread() {
        let (sut, addAccountSpy) = makeSUT()
        sut.loadViewIfNeeded()
        sut.signUp?(makeSignUpViewModel())
        let exp = expectation(description: "waiting")
        DispatchQueue.global().async {
            addAccountSpy.completeWithError(.unexpected)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1)
    }
}

extension SignUpComposerTests {

    private func makeSUT(
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> (SignUpViewController, AddAccountSpy) {
        let addAccountSpy = AddAccountSpy()
        let sut = SignUpComposer.composeController(with: MainQueueDispatchDecorator(addAccountSpy))

        checkMemoryLeak(for: sut, file: file, line: line)

        return (sut, addAccountSpy)
    }
}
