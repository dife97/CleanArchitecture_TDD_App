import Foundation
import Data

public final class URLSessionAdapter {

    private let session: URLSession

    public init(session: URLSession = .shared) {
        self.session = session
    }

    public func post(
        to url: URL,
        with data: Data?,
        onComplete: @escaping (Result<Data, HTTPError>) -> Void
    ) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = data

        session.dataTask(with: request) { data, response, error in
            if error != nil {
                onComplete(.failure(.noConnectivity))
            }
        }.resume()
    }
}
