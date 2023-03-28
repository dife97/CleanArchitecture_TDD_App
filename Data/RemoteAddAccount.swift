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

    public func add(account: AddAccountModel.Request) {
        httpClient.post(to: url, with: account.toData())
    }
}
