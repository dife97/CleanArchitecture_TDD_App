import XCTest

class SignUpPresenter {

    private let alertView: AlertView

    init(alertView: AlertView) {
        self.alertView = alertView
    }

    func signUp(viewModel: SignUpViewModel) {
        if viewModel.name == nil || viewModel.name!.isEmpty {
            alertView.showMessage(viewModel: AlertViewModel(title: "Falha na validação", message: "O campo nome é obrigatório"))
        }
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
        let alertViewSpy = AlertViewSpy()
        let sut = SignUpPresenter(alertView: alertViewSpy)
        let signUpViewModel = SignUpViewModel(
            name: nil,
            email: "anyEmail@email.com",
            password: "anyPassword",
            passwordConfirmation: "anyPassword"
        )

        sut.signUp(viewModel: signUpViewModel)

        XCTAssertEqual(alertViewSpy.viewModel, AlertViewModel(title: "Falha na validação", message: "O campo nome é obrigatório"))
    }
}

class AlertViewSpy: AlertView {

    private(set) var viewModel: AlertViewModel?
    func showMessage(viewModel: AlertViewModel) {
        self.viewModel = viewModel
    }
}
