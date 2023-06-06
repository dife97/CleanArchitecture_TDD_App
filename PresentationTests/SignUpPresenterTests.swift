import XCTest

class SignUpPresenter {

    private let alertView: AlertView

    init(alertView: AlertView) {
        self.alertView = alertView
    }

    func signUp(viewModel: SignUpViewModel) {
        if let errorMessage = validate(viewModel: viewModel) {
            alertView.showMessage(viewModel: AlertViewModel(title: "Falha na validação", message: errorMessage))
        }
    }

    private func validate(viewModel: SignUpViewModel) -> String? {
        if viewModel.name == nil || viewModel.name!.isEmpty {
            return "O campo nome é obrigatório"
        }

        else if viewModel.email == nil || viewModel.email!.isEmpty {
            return "O campo email é obrigatório"
        }

        else if viewModel.password == nil || viewModel.password!.isEmpty {
            return "O campo senha é obrigatório"
        }

        else if viewModel.passwordConfirmation == nil || viewModel.passwordConfirmation!.isEmpty {
            return "O campo confirmar senha é obrigatório"
        }

        return nil
    }
}

struct SignUpViewModel {
    let name: String?
    let email: String?
    let password: String?
    let passwordConfirmation: String?
}

protocol AlertView {
    func showMessage(viewModel: AlertViewModel)
}

struct AlertViewModel: Equatable {
    let title: String
    let message: String
}

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

class AlertViewSpy: AlertView {

    private(set) var viewModel: AlertViewModel?
    func showMessage(viewModel: AlertViewModel) {
        self.viewModel = viewModel
    }
}
