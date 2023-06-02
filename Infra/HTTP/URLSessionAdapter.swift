import Foundation
import Data

public final class URLSessionAdapter: HTTPPostClient {

    private let session: URLSession

    public init(session: URLSession = .shared) {
        self.session = session
    }

    public func post(
        to url: URL,
        with data: Data?,
        onComplete: @escaping (Result<Data?, HTTPError>) -> Void
    ) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = data

        session.dataTask(with: request) { data, response, error in
            if error == nil {
                guard let response = response as? HTTPURLResponse else {
                    onComplete(.failure(.noConnectivity))
                    return
                }

                if let data {
                    let statusCode = response.statusCode
                    
                    if data.count == 0 && statusCode != 204 {
                        onComplete(.failure(.noConnectivity))
                        return
                    }

                    switch statusCode {
                    case 204:
                        onComplete(.success(nil))

                    case 200...299:
                        onComplete(.success(data))

                    case 300...399:
                        onComplete(.failure(.noConnectivity))

                    case 401:
                        onComplete(.failure(.unauthorized))

                    case 403:
                        onComplete(.failure(.forbidden))

                    case 400...499:
                        onComplete(.failure(.badRequest))

                    case 500...599:
                        onComplete(.failure(.serverError))

                    default:
                        onComplete(.failure(.noConnectivity))
                    }
                } else {
                    onComplete(.failure(.noConnectivity))
                }
            } else {
                onComplete(.failure(.noConnectivity))
            }
        }.resume()
    }
}
