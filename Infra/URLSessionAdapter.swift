import Foundation

public final class URLSessionAdapter {

    private let session: URLSession

    public init(session: URLSession = .shared) {
        self.session = session
    }

    public func post(to url: URL) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        session.dataTask(with: request) { _, _, _ in }.resume()
    }
}
