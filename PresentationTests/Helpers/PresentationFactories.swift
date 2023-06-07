import XCTest
import Presentation

extension XCTestCase {

    func makeSignUpViewModel(
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

    func makeRequiredAlertViewModel(fieldName: String) -> AlertViewModel {
        AlertViewModel(title: "Falha na validação", message: "O campo \(fieldName) é obrigatório")
    }

    func makeInvalidAlertViewModel(fieldName: String) -> AlertViewModel {
        AlertViewModel(title: "Falha na validação", message: "O campo \(fieldName) é inválido")
    }

    func makeErrorAlertViewModel(message: String) -> AlertViewModel {
        AlertViewModel(title: "Erro", message: message)
    }

    func makeSuccessAlertViewModel(message: String) -> AlertViewModel {
        AlertViewModel(title: "Sucesso", message: message)
    }
}
