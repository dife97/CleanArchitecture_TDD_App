import XCTest
import Infra

final class URLSessionAdapterTests: XCTestCase {

    func test_post_shouldMakeRequestWithValidURLAndMethod() throws {
        let url = try makeURL()
        let data = makeValidData()
        testRequestFor(url: url, data: data) { request in
            XCTAssertEqual(url, request.url)
            XCTAssertEqual("POST", request.httpMethod)
            XCTAssertNotNil(request.httpBodyStream)
        }
    }

    func test_post_shouldMakeRequestWithNoData() throws {
        testRequestFor(data: nil) { request in
            XCTAssertNil(request.httpBodyStream)
        }
    }
}

extension URLSessionAdapterTests {

    private func makeSUT(
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> URLSessionAdapter {
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [URLProtocolStub.self]
        let session = URLSession(configuration: configuration)
        let sut = URLSessionAdapter(session: session)

        checkMemoryLeak(for: sut, file: file, line: line)

        return sut
    }

    private func testRequestFor(
        url: URL = URL(string: "any-url.com")!,
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
