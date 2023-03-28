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
        let data = try? JSONEncoder().encode(addAccountModel)

        XCTAssertEqual(httpClient.data, data)
    }
}

extension RemoteAddAccountTests {

    func makeSUT(url: URL = URL(string: "any-url.com")!) -> (RemoteAddAccount, HTTPClientSpy) {
        let url = url
        let httpClient = HTTPClientSpy()
        let sut = RemoteAddAccount(url: url, httpClient: httpClient)

        return (sut, httpClient)
    }

    func makeAddAccountRequestModel() -> AddAccountModel.Request {
        AddAccountModel.Request(
            name: "anyName",
            email: "anyEmail@email.com",
            password: "anyPassword",
            passwordConfirmation: "anyPassword"
        )
    }
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
