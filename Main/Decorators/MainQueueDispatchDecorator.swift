import Foundation
import Domain

public final class MainQueueDispatchDecorator<T> {

    private let instance: T

    public init(_ instance: T) {
        self.instance = instance
    }

    func dispatch(completion: @escaping () -> Void) {
        guard Thread.isMainThread else { return DispatchQueue.main.async(execute: completion)}
        completion()
    }
}

extension MainQueueDispatchDecorator: AddAccount where T: AddAccount {

    public func add(
        account: AddAccountModel.Request,
        onComplete: @escaping (Result<AddAccountModel.Response, DomainError>) -> Void
    ) {
        instance.add(account: account) { [weak self] result in
            self?.dispatch { onComplete(result) }
        }
    }
}
