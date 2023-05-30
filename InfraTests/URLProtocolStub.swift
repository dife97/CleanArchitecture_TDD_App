import Foundation

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
