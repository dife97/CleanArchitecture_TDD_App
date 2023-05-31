import Foundation

public final class URLSessionAdapter {

    private let session: URLSession

    public init(session: URLSession = .shared) {
        self.session = session
    }

    public func post(to url: URL, with data: Data?) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = data

        session.dataTask(with: request) { _, _, _ in }.resume()
    }
}
