import Domain

class AddAccountSpy: AddAccount {

    private(set) var addAccountModel: AddAccountModel.Request?
    func add(account: AddAccountModel.Request, onComplete: @escaping (Result<AddAccountModel.Response, DomainError>) -> Void) {
        addAccountModel = account
    }
}
