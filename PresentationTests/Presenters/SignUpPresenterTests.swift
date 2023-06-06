import XCTest
import Presentation

final class SignUpPresenterTests: XCTestCase {

    func test_signUp_should_show_error_message_if_name_is_not_provided() {
        let (sut, alertViewSpy) = makeSUT()
        let signUpViewModel = SignUpViewModel(
            name: nil,
            email: "anyEmail@email.com",
            password: "anyPassword",
            passwordConfirmation: "anyPassword"
        )

        sut.signUp(viewModel: signUpViewModel)

        XCTAssertEqual(alertViewSpy.viewModel, AlertViewModel(title: "Falha na validação", message: "O campo nome é obrigatório"))
    }

    func test_signUp_should_show_error_message_if_email_is_not_provided() {
        let (sut, alertViewSpy) = makeSUT()
        let signUpViewModel = SignUpViewModel(
            name: "Any Name",
            email: nil,
            password: "anyPassword",
            passwordConfirmation: "anyPassword"
        )

        sut.signUp(viewModel: signUpViewModel)

        XCTAssertEqual(alertViewSpy.viewModel, AlertViewModel(title: "Falha na validação", message: "O campo email é obrigatório"))
    }

    func test_signUp_should_show_error_message_if_password_is_not_provided() {
        let (sut, alertViewSpy) = makeSUT()
        let signUpViewModel = SignUpViewModel(
            name: "Any Name",
            email: "anyEmail@email.com",
            password: nil,
            passwordConfirmation: "anyPassword"
        )

        sut.signUp(viewModel: signUpViewModel)

        XCTAssertEqual(alertViewSpy.viewModel, AlertViewModel(title: "Falha na validação", message: "O campo senha é obrigatório"))
    }

    func test_signUp_should_show_error_message_if_password_confirmation_is_not_provided() {
        let (sut, alertViewSpy) = makeSUT()
        let signUpViewModel = SignUpViewModel(
            name: "Any Name",
            email: "anyEmail@email.com",
            password: "anyPassword",
            passwordConfirmation: nil
        )

        sut.signUp(viewModel: signUpViewModel)

        XCTAssertEqual(alertViewSpy.viewModel, AlertViewModel(title: "Falha na validação", message: "O campo confirmar senha é obrigatório"))
    }
}

extension SignUpPresenterTests {

    private func makeSUT() -> (SignUpPresenter, AlertViewSpy) {
        let alertViewSpy = AlertViewSpy()
        let sut = SignUpPresenter(alertView: alertViewSpy)

        return (sut, alertViewSpy)
    }
}


