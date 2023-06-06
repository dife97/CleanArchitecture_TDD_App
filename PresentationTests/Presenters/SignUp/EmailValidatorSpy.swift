import Presentation

class EmailValidatorSpy: EmailValidator {

    private var isValid = true
    private(set) var email: String?
    func isValid(email: String) -> Bool {
        self.email = email
        return isValid
    }

    func simulateInvalidEmail() {
        isValid = false
    }
}
