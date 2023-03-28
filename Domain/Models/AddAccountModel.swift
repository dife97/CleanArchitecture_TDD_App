import Foundation

public enum AddAccountModel {
    public struct Request: Model {
        let name: String
        let email: String
        let password: String
        let passwordConfirmation: String

        public init(
            name: String,
            email: String,
            password: String,
            passwordConfirmation: String
        ) {
            self.name = name
            self.email = email
            self.password = password
            self.passwordConfirmation = passwordConfirmation
        }
    }

    public struct Response: Model {
        let id: String
        let name: String
        let email: String
        let password: String

        public init(
            id: String,
            name: String,
            email: String,
            password: String
        ) {
            self.id = id
            self.name = name
            self.email = email
            self.password = password
        }
    }
}
