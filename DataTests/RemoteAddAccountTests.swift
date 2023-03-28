import XCTest

class RemoteAddAccount {
    private let url: URL
    private let httpClient: HTTPClient

    init(
        url: URL,
        httpClient: HTTPClient
    ) {
        self.url = url
        self.httpClient = httpClient
    }

    func add() {
        httpClient.post(url: url)
    }
}

final class RemoteAddAccountTests: XCTestCase {

    func test_() {
        guard let url = URL(string: "any-url.com") else { return }
        let httpClient = HTTPClientSpy()
        let sut = RemoteAddAccount(url: url, httpClient: httpClient)
        sut.add()
        XCTAssertEqual(httpClient.url, url)
    }
}

protocol HTTPClient {
    func post(url: URL)
}

class HTTPClientSpy: HTTPClient {

    var url: URL?

    func post(url: URL) {
        self.url = url
    }
}
