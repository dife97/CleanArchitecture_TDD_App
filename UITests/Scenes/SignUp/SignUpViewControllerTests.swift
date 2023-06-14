import XCTest
import UIKit
import Presentation
@testable import UI

final class SignUpViewControllerTests: XCTestCase {

    func test_loading_is_hidden_on_start() {
        XCTAssertFalse(makeSUT().loadingView.isAnimating)
    }

    func test_sut_implements_loadingView() {
        XCTAssertNotNil(makeSUT() as LoadingView)
    }

    func test_sut_implements_alertView() {
        XCTAssertNotNil(makeSUT() as AlertView)
    }

    func test_saveButton_calls_signUp_when_tapped() {
        var signUpViewModel: SignUpViewModel?
        let sut = makeSUT { signUpViewModel = $0 }

        sut.saveButton?.simulateTap()

        let expectedViewModel = SignUpViewModel(
            name: sut.nameTextField?.text,
            email: sut.emailTextField?.text,
            password: sut.passwordTextField?.text,
            passwordConfirmation: sut.passwordConfirmationTextField?.text
        )

        XCTAssertEqual(signUpViewModel, expectedViewModel)
    }
}

extension SignUpViewControllerTests {

    private func makeSUT(signUpSpy: ((SignUpViewModel) -> Void)? = nil) -> SignUpViewController {
        let sut = SignUpViewController.instantiate()

        sut.signUp = signUpSpy
        sut.loadViewIfNeeded()

        return sut
    }
}
