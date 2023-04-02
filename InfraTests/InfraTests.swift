import XCTest
import Infra
import Alamofire

final class InfraTests: XCTestCase {

    func test_() {
        let url = makeURL()
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [URLProtocolStub.self]
        let session = Session(configuration: configuration)

        let sut = AlamofireAdapter(session: session)
        sut.post(to: url)
        let exp = expectation(description: "waiting")
        URLProtocolStub.observeRequest { request in
            XCTAssertEqual(url, request.url)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1)
    }
}

class URLProtocolStub: URLProtocol {

    static var emit: ((URLRequest) -> Void)?
    static func observeRequest(completion: @escaping (URLRequest) -> Void) {
        URLProtocolStub.emit = completion
    }

    override open class func canInit(with request: URLRequest) -> Bool { true }

    override open class func canonicalRequest(for request: URLRequest) -> URLRequest { request }

    override open func stopLoading() {}

    override open func startLoading() {
        URLProtocolStub.emit?(request)
    }
}
