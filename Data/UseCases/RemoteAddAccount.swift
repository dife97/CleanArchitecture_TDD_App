import Foundation
import Domain

public final class RemoteAddAccount {

    private let url: URL
    private let httpClient: HTTPPostClient

    public init(
        url: URL,
        httpClient: HTTPPostClient
    ) {
        self.url = url
        self.httpClient = httpClient
    }

    public func add(account: AddAccountModel.Request, onComplete: @escaping (DomainError) -> Void) {
        httpClient.post(to: url, with: account.toData()) { error in
            onComplete(.unexpected)
        }
    }
}
