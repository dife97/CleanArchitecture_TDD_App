import XCTest
import Domain

class RemoteAddAccount {

    private let url: URL
    private let httpClient: HTTPPostClient

    init(
        url: URL,
        httpClient: HTTPPostClient
    ) {
        self.url = url
        self.httpClient = httpClient
    }

    func add(account: AddAccountModel.Request) {
        httpClient.post(url: url)
    }
}

final class RemoteAddAccountTests: XCTestCase {

    func test_add_should_call_httpClient_with_correct_url() {
        guard let url = URL(string: "any-url.com") else { return }
        let httpClient = HTTPClientSpy()
        let sut = RemoteAddAccount(url: url, httpClient: httpClient)
        sut.add(account: <#T##AddAccountModel.Request#>)
        XCTAssertEqual(httpClient.url, url)
    }

    func test_add_should_call_httpClient_with_correct_data() {
        guard let url = URL(string: "any-url.com") else { return }
        let httpClient = HTTPClientSpy()
        let sut = RemoteAddAccount(url: url, httpClient: httpClient)
        sut.add(account: <#T##AddAccountModel.Request#>)
        XCTAssertEqual(httpClient.data, data)
    }
}

extension RemoteAddAccountTests {

}

protocol HTTPPostClient {
    func post(url: URL)
}

class HTTPClientSpy: HTTPPostClient {

    var url: URL?

    func post(url: URL) {
        self.url = url
    }
}