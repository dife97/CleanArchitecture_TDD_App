import XCTest
import Domain
import Presentation

final class SignUpPresenterTests: XCTestCase {

    func test_signUp_should_show_error_message_if_name_is_not_provided() {
        let alertViewSpy = AlertViewSpy()
        let sut = makeSUT(alertView: alertViewSpy)
        let expectation = expectation(description: "waiting")

        alertViewSpy.observe { [weak self] viewModel in
            XCTAssertEqual(viewModel, self?.makeRequiredAlertViewModel(fieldName: "nome"))
            expectation.fulfill()
        }

        sut.signUp(viewModel: makeSignUpViewModel(name: nil))
        wait(for: [expectation], timeout: 1)
    }

    func test_signUp_should_show_error_message_if_email_is_not_provided() {
        let alertViewSpy = AlertViewSpy()
        let sut = makeSUT(alertView: alertViewSpy)
        let expectation = expectation(description: "waiting")

        alertViewSpy.observe { [weak self] viewModel in
            XCTAssertEqual(viewModel, self?.makeRequiredAlertViewModel(fieldName: "email"))
            expectation.fulfill()
        }

        sut.signUp(viewModel: makeSignUpViewModel(email: nil))
        wait(for: [expectation], timeout: 1)
    }

    func test_signUp_should_show_error_message_if_password_is_not_provided() {
        let alertViewSpy = AlertViewSpy()
        let sut = makeSUT(alertView: alertViewSpy)
        let expectation = expectation(description: "waiting")

        alertViewSpy.observe { [weak self] viewModel in
            XCTAssertEqual(viewModel, self?.makeRequiredAlertViewModel(fieldName: "senha"))
            expectation.fulfill()
        }

        sut.signUp(viewModel: makeSignUpViewModel(password: nil))
        wait(for: [expectation], timeout: 1)
    }

    func test_signUp_should_show_error_message_if_password_confirmation_is_not_provided() {
        let alertViewSpy = AlertViewSpy()
        let sut = makeSUT(alertView: alertViewSpy)
        let expectation = expectation(description: "waiting")

        alertViewSpy.observe { [weak self] viewModel in
            XCTAssertEqual(viewModel, self?.makeRequiredAlertViewModel(fieldName: "confirmar senha"))
            expectation.fulfill()
        }

        sut.signUp(viewModel: makeSignUpViewModel(passwordConfirmation: nil))
        wait(for: [expectation], timeout: 1)
    }

    func test_signUp_should_show_error_message_if_password_confirmation_is_not_match() {
        let alertViewSpy = AlertViewSpy()
        let sut = makeSUT(alertView: alertViewSpy)
        let expectation = expectation(description: "waiting")

        alertViewSpy.observe { [weak self] viewModel in
            XCTAssertEqual(viewModel, self?.makeInvalidAlertViewModel(fieldName: "confirmar senha"))
            expectation.fulfill()
        }

        sut.signUp(viewModel: makeSignUpViewModel(passwordConfirmation: "wrongPassword"))
        wait(for: [expectation], timeout: 1)
    }

    func test_signUp_should_show_error_message_if_invalid_email_is_provided() {
        let alertViewSpy = AlertViewSpy()
        let emailValidatorSpy = EmailValidatorSpy()
        let sut = makeSUT(alertView: alertViewSpy, emailValidator: emailValidatorSpy)
        let expectation = expectation(description: "waiting")

        alertViewSpy.observe { [weak self] viewModel in
            XCTAssertEqual(viewModel, self?.makeInvalidAlertViewModel(fieldName: "email"))
            expectation.fulfill()
        }

        emailValidatorSpy.simulateInvalidEmail()
        sut.signUp(viewModel: makeSignUpViewModel(email: "invalid_email@email.com"))
        wait(for: [expectation], timeout: 1)
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

    func test_signUp_should_show_error_message_if_addAccount_fails() {
        let alertViewSpy = AlertViewSpy()
        let addAccountSpy = AddAccountSpy()
        let sut = makeSUT(alertView: alertViewSpy, addAccount: addAccountSpy)
        let expectation = expectation(description: "waiting")

        alertViewSpy.observe { [weak self] viewModel in
            XCTAssertEqual(viewModel, self?.makeErrorAlertViewModel(message: "Algo inesperado aconteceu, tente novamente em alguns instantes"))
            expectation.fulfill()
        }

        sut.signUp(viewModel: makeSignUpViewModel())
        addAccountSpy.completeWithError(.unexpected)
        wait(for: [expectation], timeout: 1)
    }

    func test_signUp_should_show_loading_before_and_after_addAccount() {
        let loadingViewSpy = LoadingViewSpy()
        let addAccountSpy = AddAccountSpy()
        let sut = makeSUT(addAccount: addAccountSpy, loadingView: loadingViewSpy)
        let expectation1 = expectation(description: "waiting")
        let expectation2 = expectation(description: "waiting")

        loadingViewSpy.observe { viewModel in
            XCTAssertEqual(viewModel, LoadingViewModel(isLoading: true))
            expectation1.fulfill()
        }
        sut.signUp(viewModel: makeSignUpViewModel())
        wait(for: [expectation1], timeout: 1)


        loadingViewSpy.observe { viewModel in
            XCTAssertEqual(viewModel, LoadingViewModel(isLoading: false))
            expectation2.fulfill()
        }
        addAccountSpy.completeWithError(.unexpected)
        wait(for: [expectation2], timeout: 1)
    }
}

extension SignUpPresenterTests {

    private func makeSUT(
        alertView: AlertViewSpy = AlertViewSpy(),
        emailValidator: EmailValidatorSpy = EmailValidatorSpy(),
        addAccount: AddAccountSpy = AddAccountSpy(),
        loadingView: LoadingViewSpy = LoadingViewSpy(),
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> SignUpPresenter {

        let sut = SignUpPresenter(
            alertView: alertView,
            emailValidator: emailValidator,
            addAccount: addAccount,
            loadingView: loadingView
        )

        checkMemoryLeak(for: sut, file: file, line: line)

        return sut
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

    private func makeErrorAlertViewModel(message: String) -> AlertViewModel {
        AlertViewModel(title: "Erro", message: message)
    }
}
