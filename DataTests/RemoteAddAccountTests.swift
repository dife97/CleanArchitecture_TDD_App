import XCTest
import Domain
import Data

final class RemoteAddAccountTests: XCTestCase {

    func test_add_should_call_httpClient_with_correct_url() {
        let url = URL(string: "any-url.com")!
        let (sut, httpClient) = makeSUT(url: url)
        let addAccountModel = makeAddAccountRequestModel()
        sut.add(account: addAccountModel)

        XCTAssertEqual(httpClient.url, url)
    }

    func test_add_should_call_httpClient_with_correct_data() {
        let (sut, httpClient) = makeSUT()
        let addAccountModel = makeAddAccountRequestModel()
        sut.add(account: addAccountModel)

        XCTAssertEqual(httpClient.data, addAccountModel.toData())
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
