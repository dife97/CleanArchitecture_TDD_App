import Domain

final class SignUpMapper {

    static func toAddAccountResponseModel(viewModel: SignUpViewModel) -> AddAccountModel.Request {
        AddAccountModel.Request(
            name: viewModel.name ?? "",
            email: viewModel.email ?? "",
            password: viewModel.password ?? "",
            passwordConfirmation: viewModel.passwordConfirmation ?? ""
        )
    }
}
