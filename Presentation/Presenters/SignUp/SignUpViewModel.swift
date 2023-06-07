import Domain

public struct SignUpViewModel: Model {
    let name: String?
    public let email: String?
    let password: String?
    let passwordConfirmation: String?

    public init(
        name: String?,
        email: String?,
        password: String?,
        passwordConfirmation: String?
    ) {
        self.name = name
        self.email = email
        self.password = password
        self.passwordConfirmation = passwordConfirmation
    }
}
