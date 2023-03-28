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
        let data = try? JSONEncoder().encode(account)
        httpClient.post(to: url, with: data)
    }
}

final class RemoteAddAccountTests: XCTestCase {

    func test_add_should_call_httpClient_with_correct_url() {
        guard let url = URL(string: "any-url.com") else { return }
        let httpClient = HTTPClientSpy()
        let sut = RemoteAddAccount(url: url, httpClient: httpClient)
        let addAccountModel = AddAccountModel.Request(
            name: "anyName",
            email: "anyEmail@email.com",
            password: "anyPassword",
            passwordConfirmation: "anyPassword"
        )
        sut.add(account: addAccountModel)

        XCTAssertEqual(httpClient.url, url)
    }

    func test_add_should_call_httpClient_with_correct_data() {
        guard let url = URL(string: "any-url.com") else { return }
        let httpClient = HTTPClientSpy()
        let sut = RemoteAddAccount(url: url, httpClient: httpClient)
        let addAccountModel = AddAccountModel.Request(
            name: "anyName",
            email: "anyEmail@email.com",
            password: "anyPassword",
            passwordConfirmation: "anyPassword"
        )
        sut.add(account: addAccountModel)
        let data = try? JSONEncoder().encode(addAccountModel)

        XCTAssertEqual(httpClient.data, data)
    }
}

extension RemoteAddAccountTests {

}

protocol HTTPPostClient {
    func post(to url: URL, with data: Data?)
}

class HTTPClientSpy: HTTPPostClient {

    var url: URL?
    var data: Data?

    func post(to url: URL, with data: Data?) {
        self.url = url
        self.data = data
    }
}
