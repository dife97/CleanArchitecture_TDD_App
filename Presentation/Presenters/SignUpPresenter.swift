public final class SignUpPresenter {

    private let alertView: AlertView

    public init(alertView: AlertView) {
        self.alertView = alertView
    }

    public func signUp(viewModel: SignUpViewModel) {
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
