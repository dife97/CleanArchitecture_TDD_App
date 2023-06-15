import Foundation
import Domain
import Data
import Infra

final class UseCaseFactory {

    private static let httpClient = URLSessionAdapter()
    private static let apiBaseURL = "https://clean-node-api.herokuapp.com/api"

    private static func makeURL(path: String) -> URL {
        URL(string: "\(apiBaseURL)\(path)")!
    }

    static func makeRemoteAddAccount() -> AddAccount {
        let url = makeURL(path: "/signUp")
        return RemoteAddAccount(
            url: url,
            httpClient: httpClient
        )
    }
}
