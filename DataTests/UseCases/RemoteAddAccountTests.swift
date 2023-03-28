import XCTest
import Domain
import Data

final class RemoteAddAccountTests: XCTestCase {

    func test_add_should_call_httpClient_with_correct_url() {
        let url = URL(string: "any-url.com")!
        let (sut, httpClient) = makeSUT(url: url)
        sut.add(account: makeAddAccountRequestModel()) { _ in }

        XCTAssertEqual(httpClient.urls, [url])
    }

    func test_add_should_call_httpClient_with_correct_data() {
        let (sut, httpClient) = makeSUT()
        let addAccountModel = makeAddAccountRequestModel()
        sut.add(account: addAccountModel) { _ in }

        XCTAssertEqual(httpClient.data, addAccountModel.toData())
    }

    func test_add_should_complete_with_error_if_client_completes_with_error() {
        let (sut, httpClient) = makeSUT()
        let exp = expectation(description: "waiting")
        sut.add(account: makeAddAccountRequestModel()) { result in
            switch result {
            case .failure(let error):
                XCTAssertEqual(error, .unexpected)
            case .success(_):
                XCTFail("Expected error but received \(result) instead")
            }
            exp.fulfill()
        }
        httpClient.completeWithError(.noConnectivity)
        wait(for: [exp], timeout: 1)
    }
}

extension RemoteAddAccountTests {

    private func makeSUT(url: URL = URL(string: "any-url.com")!) -> (RemoteAddAccount, HTTPClientSpy) {
        let url = url
        let httpClient = HTTPClientSpy()
        let sut = RemoteAddAccount(url: url, httpClient: httpClient)

        return (sut, httpClient)
    }

    private func makeAddAccountRequestModel() -> AddAccountModel.Request {
        AddAccountModel.Request(
            name: "anyName",
            email: "anyEmail@email.com",
            password: "anyPassword",
            passwordConfirmation: "anyPassword"
        )
    }
}
