import Foundation
import Domain
import Data
import Infra

final class UseCaseFactory {

    private static let httpClient = URLSessionAdapter()
    private static let apiBaseURL = Environment.variable(.apiBaseURL)

    private static func makeURL(path: String) -> URL {
        URL(string: "\(apiBaseURL)\(path)")!
    }

    static func makeRemoteAddAccount() -> AddAccount {
        let url = makeURL(path: "/signUp")
        let remoteAddAccount = RemoteAddAccount(
            url: url,
            httpClient: httpClient
        )
        return MainQueueDispatchDecorator(remoteAddAccount)
    }
}

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
