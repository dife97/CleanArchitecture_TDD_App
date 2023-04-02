import XCTest
import Domain
import Data

final class RemoteAddAccountTests: XCTestCase {

    func test_add_should_call_httpClient_with_correct_url() {
        let url = makeURL()
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
        expect(sut, completeWith: .failure(.unexpected), when: {
            httpClient.completeWithError(.noConnectivity)
        })
    }

    func test_add_should_complete_with_account_if_client_completes_with_validData() {
        let (sut, httpClient) = makeSUT()
        let account = makeAccountModel()
        expect(sut, completeWith: .success(account), when: {
            httpClient.completeWithData(account.toData()!)
        })
    }

    func test_add_should_complete_with_error_if_client_completes_with_invalidData() {
        let (sut, httpClient) = makeSUT()
        expect(sut, completeWith: .failure(.unexpected), when: {
            httpClient.completeWithData(makeInvalidData())
        })
    }
}

extension RemoteAddAccountTests {

    private func makeSUT(url: URL = URL(string: "any-url.com")!) -> (RemoteAddAccount, HTTPClientSpy) {
        let url = url
        let httpClient = HTTPClientSpy()
        let sut = RemoteAddAccount(url: url, httpClient: httpClient)

        return (sut, httpClient)
    }

    private func expect(_ sut: RemoteAddAccount,
                        completeWith expectedResult: Result<AddAccountModel.Response, DomainError>,
                        when action: () -> Void) {

        let exp = expectation(description: "waiting")
        sut.add(account: makeAddAccountRequestModel()) { receivedResult in
            switch (expectedResult, receivedResult) {
            case (.failure(let expectedError),
                  .failure(let receivedError)):
                XCTAssertEqual(expectedError, receivedError)

            case (.success(let expectedAccount),
                  .success(let receivedAccount)):
                XCTAssertEqual(expectedAccount, receivedAccount)

            default:
                XCTFail("Expected \(expectedResult) but received \(receivedResult) instead")
            }
            exp.fulfill()
        }
        action()
        wait(for: [exp], timeout: 1)
    }

    private func makeURL() -> URL {
        URL(string: "any-url.com")!
    }

    private func makeAddAccountRequestModel() -> AddAccountModel.Request {
        AddAccountModel.Request(
            name: "anyName",
            email: "anyEmail@email.com",
            password: "anyPassword",
            passwordConfirmation: "anyPassword"
        )
    }

    private func makeAccountModel() -> AddAccountModel.Response {
        AddAccountModel.Response(
            id: "anyID",
            name: "anyName",
            email: "anyEmail@email.com",
            password: "anyPassword"
        )
    }

    private func makeInvalidData() -> Data {
        Data("invalid_data".utf8)
    }
}
