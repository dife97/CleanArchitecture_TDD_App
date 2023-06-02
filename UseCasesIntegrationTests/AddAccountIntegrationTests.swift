import XCTest
import Domain
import Data
import Infra

final class AddAccountIntegrationTests: XCTestCase {

    func test_addAccount() throws {
        let url = try XCTUnwrap(URL(string: "http://localhost:3001/api/signup"))
        let urlSessionAdapter = URLSessionAdapter()
        let sut = RemoteAddAccount(url: url, httpClient: urlSessionAdapter)
        let newAccount = AddAccountModel.Request(
            name: "Diego Ferreira",
            email: "diferodrigues@gmail.com",
            password: "teste123",
            passwordConfirmation: "teste123"
        )

        let expectation = expectation(description: "waiting")
        sut.add(account: newAccount) { result in
            switch result {
            case .success(let receivedAccount):
                XCTAssertNotNil(receivedAccount.id)
                XCTAssertEqual(receivedAccount.name, newAccount.name)
                XCTAssertEqual(receivedAccount.email, newAccount.email)

            case .failure(let error):
                print(error.localizedDescription)
                XCTFail("Expected sucess got \(result) instead.")
            }

            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5)
    }
}
