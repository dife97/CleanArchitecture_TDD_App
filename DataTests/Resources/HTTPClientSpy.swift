import Foundation
import Data

class HTTPClientSpy: HTTPPostClient {

    var urls: [URL] = []
    var data: Data?
    var onComplete: ((Result<Data, HTTPError>) -> Void)?

    func post(to url: URL, with data: Data?, onComplete: @escaping (Result<Data, HTTPError>) -> Void) {
        self.urls.append(url)
        self.data = data
        self.onComplete = onComplete
    }

    func completeWithError(_ error: HTTPError) {
        onComplete?(.failure(error))
    }

    func completeWithData(_ data: Data) {
        onComplete?(.success(data))
    }
}
