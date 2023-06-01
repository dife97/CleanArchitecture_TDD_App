import XCTest
import Infra

final class URLSessionAdapterTests: XCTestCase {

    func test_post_should_make_request_with_valid_url_and_method() throws {
        let url = try makeURL()
        let data = makeValidData()
        try testRequestFor(url: url, data: data) { request in
            XCTAssertEqual(url, request.url)
            XCTAssertEqual("POST", request.httpMethod)
            XCTAssertNotNil(request.httpBodyStream)
        }
    }

    func test_post_should_make_request_with_no_data() throws {
        try testRequestFor(url: try makeURL(), data: nil) { request in
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
        url: URL,
        data: Data?,
        action: @escaping (URLRequest) -> Void
    ) throws {
        let sut = makeSUT()
        let expectation = expectation(description: "waiting")
        var request: URLRequest?

        sut.post(to: url, with: data) { _ in expectation.fulfill() }

        URLProtocolStub.observeRequest { request = $0 }

        wait(for: [expectation], timeout: 1)
        
        action(try XCTUnwrap(request))
    }
}
