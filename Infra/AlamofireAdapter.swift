import Foundation
import Alamofire

public final class AlamofireAdapter {

    private let session: Session

    public init(session: Session = .default) {
        self.session = session
    }

    public func post(to url: URL) {
        session.request(url, method: .post).resume()
    }
}
