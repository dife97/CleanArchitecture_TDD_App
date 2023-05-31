import XCTest
import Infra

final class URLSessionAdapterTests: XCTestCase {

    func test_post_shouldMakeRequestWithValidURLAndMethod() {
        let sut = makeSUT()
        let url = makeURL()
        let data = makeValidData()

        sut.post(to: url, with: data)

        let expectation = expectation(description: "waiting")
        URLProtocolStub.observeRequest { request in
            XCTAssertEqual(url, request.url)
            XCTAssertEqual("POST", request.httpMethod)
            XCTAssertNotNil(request.httpBodyStream)
            expectation.fulfill()
        }
        wait(for: [expectation])
    }

    func test_post_shouldMakeRequestWithNoData() {
        let sut = makeSUT()
        sut.post(to: makeURL(), with: nil)

        let expectation = expectation(description: "waiting")
        URLProtocolStub.observeRequest { request in
            XCTAssertNil(request.httpBodyStream)
            expectation.fulfill()
        }
        wait(for: [expectation])
    }
}

extension URLSessionAdapterTests {

    private func makeSUT() -> URLSessionAdapter {
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [URLProtocolStub.self]
        let session = URLSession(configuration: configuration)
        return URLSessionAdapter(session: session)
    }
}
