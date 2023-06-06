public final class SignUpPresenter {

    private let alertView: AlertView
    private let emailValidator: EmailValidator

    public init(
        alertView: AlertView,
        emailValidator: EmailValidator
    ) {
        self.alertView = alertView
        self.emailValidator = emailValidator
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

        else if viewModel.password != viewModel.passwordConfirmation {
            return "O campo confirmar senha é inválido"
        }

        else if !emailValidator.isValid(email: viewModel.email!) {
            return "O campo email é inválido"
        }
        
        return nil
    }
}