enum AddAccountModel {
    struct Request {
        let name: String
        let email: String
        let password: String
        let passwordConfirmation: String
    }

    struct Response {
        let id: String
        let name: String
        let email: String
        let password: String
    }
}
