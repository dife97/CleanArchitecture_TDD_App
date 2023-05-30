import XCTest
import Infra

final class URLSessionAdapterTests: XCTestCase {

    func test_post_shouldMakeRequestWithValidURLAndMethod() {
        let url = makeURL()
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [URLProtocolStub.self]
        let session = URLSession(configuration: configuration)
        let sut = URLSessionAdapter(session: session)

        sut.post(to: url)

        let expectation = expectation(description: "waiting")
        URLProtocolStub.observeRequest { request in
            XCTAssertEqual(url, request.url)
            XCTAssertEqual("POST", request.httpMethod)
            expectation.fulfill()
        }
        wait(for: [expectation])
    }
}
