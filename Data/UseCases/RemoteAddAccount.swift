import Foundation
import Domain

public final class RemoteAddAccount: AddAccount {

    private let url: URL
    private let httpClient: HTTPPostClient

    public init(
        url: URL,
        httpClient: HTTPPostClient
    ) {
        self.url = url
        self.httpClient = httpClient
    }

    public func add(account: AddAccountModel.Request, onComplete: @escaping (Result<AddAccountModel.Response, DomainError>) -> Void) {
        httpClient.post(to: url, with: account.toData()) { result in
            switch result {
            case .success(let data):
                if let model: AddAccountModel.Response = data.toModel() {
                    onComplete(.success(model))
                }

            case .failure:
                onComplete(.failure(.unexpected))
            }
        }
    }
}
