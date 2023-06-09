public protocol AddAccount {
    func add(account: AddAccountModel.Request,
             onComplete: @escaping (Result<AddAccountModel.Response, DomainError>) -> Void)
}
