import Foundation
import Data

class HTTPClientSpy: HTTPPostClient {

    var urls: [URL] = []
    var data: Data?

    func post(to url: URL, with data: Data?) {
        urls.append(url)
        self.data = data
    }
}
