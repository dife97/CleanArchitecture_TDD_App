import Foundation
import Data

class HTTPClientSpy: HTTPPostClient {

    var urls: [URL] = []
    var data: Data?
    var onComplete: ((HTTPError) -> Void)?

    func post(to url: URL, with data: Data?, onComplete: @escaping (HTTPError) -> Void) {
        self.urls.append(url)
        self.data = data
        self.onComplete = onComplete
    }

    func completeWithError(_ error: HTTPError) {
        onComplete?(error)
    }
}
