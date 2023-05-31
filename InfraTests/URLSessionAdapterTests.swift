import XCTest
import Infra

final class URLSessionAdapterTests: XCTestCase {

    func test_post_should_make_request_with_valid_url_and_method() throws {
        let url = try makeURL()
        let data = makeValidData()
        testRequestFor(url: url, data: data) { request in
            XCTAssertEqual(url, request.url)
            XCTAssertEqual("POST", request.httpMethod)
            XCTAssertNotNil(request.httpBodyStream)
        }
    }

    func test_post_should_make_request_with_no_data() throws {
        testRequestFor(data: nil) { request in
            XCTAssertNil(request.httpBodyStream)
        }
    }

    func test_post_should_complete_with_error_when_request_completes_with_error() throws {
        let sut = makeSUT()

        URLProtocolStub.simulate(data: nil, response: nil, error: makeError())

        let expectation = expectation(description: "wait")
        sut.post(to: try makeURL(), with: makeValidData()) { result in
            switch result {
            case .success:
                XCTFail("Expected error and got \(result) instead.")
            case .failure(let failure):
                XCTAssertEqual(failure, .noConnectivity)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
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
        sut.post(to: url, with: data) { _ in }
        let expectation = expectation(description: "waiting")
        URLProtocolStub.observeRequest { request in
            action(request)
            expectation.fulfill()
        }
        wait(for: [expectation])
    }
}
