import XCTest
import Domain
import Presentation

final class SignUpPresenterTests: XCTestCase {

    func test_signUp_should_show_error_message_if_name_is_not_provided() {
        let alertViewSpy = AlertViewSpy()
        let sut = makeSUT(alertView: alertViewSpy)

        sut.signUp(viewModel: makeSignUpViewModel(name: nil))

        XCTAssertEqual(alertViewSpy.viewModel, makeRequiredAlertViewModel(fieldName: "nome"))
    }

    func test_signUp_should_show_error_message_if_email_is_not_provided() {
        let alertViewSpy = AlertViewSpy()
        let sut = makeSUT(alertView: alertViewSpy)

        sut.signUp(viewModel: makeSignUpViewModel(email: nil))

        XCTAssertEqual(alertViewSpy.viewModel, makeRequiredAlertViewModel(fieldName: "email"))
    }

    func test_signUp_should_show_error_message_if_password_is_not_provided() {
        let alertViewSpy = AlertViewSpy()
        let sut = makeSUT(alertView: alertViewSpy)

        sut.signUp(viewModel: makeSignUpViewModel(password: nil))

        XCTAssertEqual(alertViewSpy.viewModel, makeRequiredAlertViewModel(fieldName: "senha"))
    }

    func test_signUp_should_show_error_message_if_password_confirmation_is_not_provided() {
        let alertViewSpy = AlertViewSpy()
        let sut = makeSUT(alertView: alertViewSpy)

        sut.signUp(viewModel: makeSignUpViewModel(passwordConfirmation: nil))

        XCTAssertEqual(alertViewSpy.viewModel, makeRequiredAlertViewModel(fieldName: "confirmar senha"))
    }

    func test_signUp_should_show_error_message_if_password_confirmation_is_not_match() {
        let alertViewSpy = AlertViewSpy()
        let sut = makeSUT(alertView: alertViewSpy)

        sut.signUp(viewModel: makeSignUpViewModel(passwordConfirmation: "wrongPassword"))

        XCTAssertEqual(alertViewSpy.viewModel, makeInvalidAlertViewModel(fieldName: "confirmar senha"))
    }

    func test_signUp_should_show_error_message_if_invalid_email_is_provided() {
        let alertViewSpy = AlertViewSpy()
        let emailValidatorSpy = EmailValidatorSpy()
        let sut = makeSUT(alertView: alertViewSpy, emailValidator: emailValidatorSpy)

        emailValidatorSpy.simulateInvalidEmail()
        sut.signUp(viewModel: makeSignUpViewModel(email: "invalid_email@email.com"))

        XCTAssertEqual(alertViewSpy.viewModel, makeInvalidAlertViewModel(fieldName: "email"))
    }

    func test_signUp_should_call_emailValidator_with_correct_email() {
        let emailValidatorSpy = EmailValidatorSpy()
        let sut = makeSUT(emailValidator: emailValidatorSpy)
        let signUpViewModel = makeSignUpViewModel()

        sut.signUp(viewModel: signUpViewModel)

        XCTAssertEqual(emailValidatorSpy.email, signUpViewModel.email)
    }

    func test_signUp_should_call_addAccount_with_correct_data() {
        let addAccountSpy = AddAccountSpy()
        let sut = makeSUT(addAccount: addAccountSpy)

        sut.signUp(viewModel: makeSignUpViewModel())

        XCTAssertEqual(addAccountSpy.addAccountModel, makeAddAccountRequestModel())
    }
}

extension SignUpPresenterTests {

    private func makeSUT(
        alertView: AlertViewSpy = AlertViewSpy(),
        emailValidator: EmailValidatorSpy = EmailValidatorSpy(),
        addAccount: AddAccountSpy = AddAccountSpy()
    ) -> SignUpPresenter {
        SignUpPresenter(
            alertView: alertView,
            emailValidator: emailValidator,
            addAccount: addAccount
        )
    }

    private func makeSignUpViewModel(
        name: String? = "Any Name",
        email: String? = "anyEmail@email.com",
        password: String? = "anyPassword",
        passwordConfirmation: String? = "anyPassword"
    ) -> SignUpViewModel {
        SignUpViewModel(
            name: name,
            email: email,
            password: password,
            passwordConfirmation: passwordConfirmation
        )
    }

    private func makeRequiredAlertViewModel(fieldName: String) -> AlertViewModel {
        AlertViewModel(title: "Falha na validação", message: "O campo \(fieldName) é obrigatório")
    }

    private func makeInvalidAlertViewModel(fieldName: String) -> AlertViewModel {
        AlertViewModel(title: "Falha na validação", message: "O campo \(fieldName) é inválido")
    }
}
