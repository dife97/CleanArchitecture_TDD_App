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
