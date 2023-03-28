import Foundation
import Data

class HTTPClientSpy: HTTPPostClient {

    var url: URL?
    var data: Data?

    func post(to url: URL, with data: Data?) {
        self.url = url
        self.data = data
    }
}
