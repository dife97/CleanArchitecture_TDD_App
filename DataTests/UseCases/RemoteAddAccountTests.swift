import XCTest
import Domain
import Data

final class RemoteAddAccountTests: XCTestCase {

    func test_add_should_call_httpClient_with_correct_url() throws {
        let url = try makeURL()
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
            httpClient.completeWithError(.badRequest)
        })
    }

    func test_add_should_complete_with_connectivity_error() {
        let (sut, httpClient) = makeSUT()

        expect(sut, completeWith: .failure(.noConnectivity), when: {
            httpClient.completeWithError(.noConnectivity)
        })
    }

    func test_add_should_complete_with_account_if_client_completes_with_validData() {
        let (sut, httpClient) = makeSUT()
        let account = makeAccountResponseModel()

        expect(sut, completeWith: .success(account), when: {
            httpClient.completeWithData(account.toData())
        })
    }

    func test_add_should_complete_with_error_if_client_completes_with_invalidData() {
        let (sut, httpClient) = makeSUT()

        expect(sut, completeWith: .failure(.unexpected), when: {
            httpClient.completeWithData(makeInvalidData())
        })
    }

    func test_add_should_not_complete_if_sut_has_been_deallocated() throws {
        let httpClient = HTTPClientSpy()
        var sut: RemoteAddAccount? = RemoteAddAccount(
            url: try makeURL(),
            httpClient: httpClient
        )
        var result: Result<AddAccountModel.Response, DomainError>?

        sut?.add(account: makeAddAccountRequestModel()) { result = $0 }
        sut = nil
        httpClient.completeWithError(.noConnectivity)

        XCTAssertNil(result)
    }
}

extension RemoteAddAccountTests {

    private func makeSUT(
        url: URL = URL(string: "any-url.com")!,
        _ file: StaticString = #filePath,
        _ line: UInt = #line
    ) -> (RemoteAddAccount, HTTPClientSpy) {
        let url = url
        let httpClient = HTTPClientSpy()
        let sut = RemoteAddAccount(
            url: url,
            httpClient: httpClient
        )

        checkMemoryLeak(for: sut, file: file, line: line)
        checkMemoryLeak(for: httpClient, file: file, line: line)

        return (sut, httpClient)
    }

    private func expect(
        _ sut: RemoteAddAccount,
        completeWith expectedResult: Result<AddAccountModel.Response, DomainError>,
        when action: () -> Void,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        let exp = expectation(description: "waiting")
        sut.add(account: makeAddAccountRequestModel()) { receivedResult in
            switch (expectedResult, receivedResult) {
            case (
                .failure(let expectedError),
                .failure(let receivedError)
            ):
                XCTAssertEqual(expectedError, receivedError, file: file, line: line)

            case (
                .success(let expectedAccount),
                .success(let receivedAccount)
            ):
                XCTAssertEqual(expectedAccount, receivedAccount, file: file, line: line)

            default:
                XCTFail("Expected \(expectedResult) but received \(receivedResult) instead", file: file, line: line)
            }

            exp.fulfill()
        }

        action()
        wait(for: [exp], timeout: 1)
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
