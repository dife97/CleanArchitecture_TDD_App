import XCTest
import Infra

final class URLSessionAdapterTests: XCTestCase {

    func test_post_shouldMakeRequestWithValidURLAndMethod() {
        let url = makeURL()
        let data = makeValidData()
        testRequestFor(url: url, data: data) { request in
            XCTAssertEqual(url, request.url)
            XCTAssertEqual("POST", request.httpMethod)
            XCTAssertNotNil(request.httpBodyStream)
        }
    }

    func test_post_shouldMakeRequestWithNoData() {
        let url = makeURL()
        testRequestFor(url: url, data: nil) { request in
            XCTAssertNil(request.httpBodyStream)
        }
    }
}

extension URLSessionAdapterTests {

    private func makeSUT() -> URLSessionAdapter {
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [URLProtocolStub.self]
        let session = URLSession(configuration: configuration)
        return URLSessionAdapter(session: session)
    }

    private func testRequestFor(
        url: URL,
        data: Data?,
        action: @escaping (URLRequest) -> Void
    ) {
        let sut = makeSUT()
        sut.post(to: url, with: data)
        let expectation = expectation(description: "waiting")
        URLProtocolStub.observeRequest { request in
            action(request)
            expectation.fulfill()
        }
        wait(for: [expectation])
    }
}
