import XCTest
import Presentation

final class SignUpPresenterTests: XCTestCase {

    func test_signUp_should_show_error_message_if_name_is_not_provided() {
        let alertViewSpy = AlertViewSpy()
        let sut = makeSUT(alertView: alertViewSpy)
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
        let alertViewSpy = AlertViewSpy()
        let sut = makeSUT(alertView: alertViewSpy)
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
        let alertViewSpy = AlertViewSpy()
        let sut = makeSUT(alertView: alertViewSpy)
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
        let alertViewSpy = AlertViewSpy()
        let sut = makeSUT(alertView: alertViewSpy)
        let signUpViewModel = SignUpViewModel(
            name: "Any Name",
            email: "anyEmail@email.com",
            password: "anyPassword",
            passwordConfirmation: nil
        )

        sut.signUp(viewModel: signUpViewModel)

        XCTAssertEqual(alertViewSpy.viewModel, AlertViewModel(title: "Falha na validação", message: "O campo confirmar senha é obrigatório"))
    }

    func test_signUp_should_show_error_message_if_password_confirmation_is_not_match() {
        let alertViewSpy = AlertViewSpy()
        let sut = makeSUT(alertView: alertViewSpy)
        let signUpViewModel = SignUpViewModel(
            name: "Any Name",
            email: "anyEmail@email.com",
            password: "anyPassword",
            passwordConfirmation: "wrongPassword"
        )

        sut.signUp(viewModel: signUpViewModel)

        XCTAssertEqual(alertViewSpy.viewModel, AlertViewModel(title: "Falha na validação", message: "Falha ao confirmar senha"))
    }

    func test_signUp_should_call_emailValidator_with_correct_email() {
        let emailValidatorSpy = EmailValidatorSpy()
        let sut = makeSUT(emailValidator: emailValidatorSpy)
        let signUpViewModel = SignUpViewModel(
            name: "Any Name",
            email: "invalid_email@email.com",
            password: "anyPassword",
            passwordConfirmation: "anyPassword"
        )

        sut.signUp(viewModel: signUpViewModel)

        XCTAssertEqual(emailValidatorSpy.email, signUpViewModel.email)
    }

    func test_signUp_should_show_error_message_if_invalid_email_is_provided() {
        let alertViewSpy = AlertViewSpy()
        let emailValidatorSpy = EmailValidatorSpy()
        let sut = makeSUT(alertView: alertViewSpy, emailValidator: emailValidatorSpy)
        let signUpViewModel = SignUpViewModel(
            name: "Any Name",
            email: "invalid_email@email.com",
            password: "anyPassword",
            passwordConfirmation: "anyPassword"
        )

        emailValidatorSpy.isValid = false
        sut.signUp(viewModel: signUpViewModel)

        XCTAssertEqual(alertViewSpy.viewModel, AlertViewModel(title: "Falha na validação", message: "E-mail inválido"))
    }
}

extension SignUpPresenterTests {

    private func makeSUT(
        alertView: AlertViewSpy = AlertViewSpy(),
        emailValidator: EmailValidatorSpy = EmailValidatorSpy()
    ) -> SignUpPresenter {
        SignUpPresenter(alertView: alertView, emailValidator: emailValidator)
    }
}

class EmailValidatorSpy: EmailValidator {

    var isValid = true
    private(set) var email: String?
    func isValid(email: String) -> Bool {
        self.email = email
        return isValid
    }
}
