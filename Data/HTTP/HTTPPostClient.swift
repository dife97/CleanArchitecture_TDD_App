import Foundation

public protocol HTTPPostClient {
    func post(to url: URL, with data: Data?, onComplete: @escaping (Result<Data?, HTTPError>) -> Void)
}
