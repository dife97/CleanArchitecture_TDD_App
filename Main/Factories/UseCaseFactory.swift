import Foundation
import Domain
import Data
import Infra

final class UseCaseFactory {

    static func makeRemoteAddAccount() -> AddAccount {
        let url = URL(string: "https://clean-node-api.herokuapp.com/api/signup")!
        let urlSessionAdapter = URLSessionAdapter()
        let remoteAddAccount = RemoteAddAccount(
            url: url,
            httpClient: urlSessionAdapter
        )

        return remoteAddAccount
    }
}
