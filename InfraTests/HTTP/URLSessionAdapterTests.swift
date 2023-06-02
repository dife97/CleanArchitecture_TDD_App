import XCTest
import Data
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
        try testRequestFor(url: makeURL(), data: nil) { request in
            XCTAssertNil(request.httpBodyStream)
        }
    }

    func test_post_should_complete_with_error_when_request_completes_with_error() throws {
        try expectResult(.failure(.noConnectivity), when: (data: nil, response: nil, error: makeError()))
    }

    func test_post_should_complete_with_error_on_all_invalid_cases() throws {
        try expectResult(.failure(.noConnectivity), when: (data: makeValidData(), response: makeHTTPResponse(), error: makeError()))
        try expectResult(.failure(.noConnectivity), when: (data: makeValidData(), response: nil, error: makeError()))
        try expectResult(.failure(.noConnectivity), when: (data: makeValidData(), response: nil, error: nil))
        try expectResult(.failure(.noConnectivity), when: (data: nil, response: makeHTTPResponse(), error: makeError()))
        try expectResult(.failure(.noConnectivity), when: (data: nil, response: makeHTTPResponse(), error: nil))
        try expectResult(.failure(.noConnectivity), when: (data: nil, response: nil, error: nil))
    }

    func test_post_should_complete_with_data_when_request_completes_with_200() throws {
        let expectedData = makeValidData()
        try expectResult(.success(expectedData), when: (data: expectedData, response: makeHTTPResponse(), error: nil))
    }

    func test_post_should_complete_with_no_data_when_request_completes_with_204() throws {
        try expectResult(.success(nil), when: (data: nil, response: makeHTTPResponse(statusCode: 204), error: nil))
        try expectResult(.success(nil), when: (data: makeEmptyData(), response: makeHTTPResponse(statusCode: 204), error: nil))
        try expectResult(.success(nil), when: (data: makeValidData(), response: makeHTTPResponse(statusCode: 204), error: nil))
    }

    func test_post_should_complete_with_error_when_request_completes_with_non_200() throws {
        try expectResult(.failure(.badRequest), when: (data: makeValidData(), response: makeHTTPResponse(statusCode: 400), error: nil))
        try expectResult(.failure(.unauthorized), when: (data: makeValidData(), response: makeHTTPResponse(statusCode: 401), error: nil))
        try expectResult(.failure(.forbidden), when: (data: makeValidData(), response: makeHTTPResponse(statusCode: 403), error: nil))
        try expectResult(.failure(.badRequest), when: (data: makeValidData(), response: makeHTTPResponse(statusCode: 450), error: nil))
        try expectResult(.failure(.badRequest), when: (data: makeValidData(), response: makeHTTPResponse(statusCode: 499), error: nil))
        try expectResult(.failure(.serverError), when: (data: makeValidData(), response: makeHTTPResponse(statusCode: 500), error: nil))
        try expectResult(.failure(.serverError), when: (data: makeValidData(), response: makeHTTPResponse(statusCode: 550), error: nil))
        try expectResult(.failure(.serverError), when: (data: makeValidData(), response: makeHTTPResponse(statusCode: 599), error: nil))
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

    private func expectResult(
        _ expectedResult: Result<Data?, HTTPError>,
        when stub: (data: Data?, response: HTTPURLResponse?, error: Error?),
        file: StaticString = #filePath,
        line: UInt = #line
    ) throws {

        let sut = makeSUT()

        URLProtocolStub.simulate(data: stub.data, response: stub.response, error: stub.error)

        let expectation = expectation(description: "wait")
        sut.post(to: try makeURL(), with: stub.data) { receivedResult in
            switch (expectedResult, receivedResult) {
            case (.success(let expectedData), .success(let receivedData)):
                XCTAssertEqual(expectedData, receivedData, file: file, line: line)

            case (.failure(let expectedFailure), .failure(let receivedFailure)):
                XCTAssertEqual(expectedFailure, receivedFailure, file: file, line: line)

            default:
                XCTFail("Expected \(expectedResult) and got \(receivedResult) instead.", file: file, line: line)
            }

            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }
}
