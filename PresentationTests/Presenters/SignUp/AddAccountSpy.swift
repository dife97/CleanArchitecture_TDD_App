import Domain

class AddAccountSpy: AddAccount {

    private(set) var addAccountModel: AddAccountModel.Request?
    var completion: ((Result<AddAccountModel.Response, DomainError>) -> Void)?
    func add(account: AddAccountModel.Request, onComplete: @escaping (Result<AddAccountModel.Response, DomainError>) -> Void) {
        addAccountModel = account
        completion = onComplete
    }

    func completeWithError(_ error: DomainError) {
        completion?(.failure(error))
    }

    func completeWithAccount(_ account: AddAccountModel.Response) {
        completion?(.success(account))
    }
}
