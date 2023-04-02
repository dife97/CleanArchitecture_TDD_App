import XCTest
import Domain

extension XCTestCase {

    func makeAccountResponseModel() -> AddAccountModel.Response {
        AddAccountModel.Response(
            id: "anyID",
            name: "anyName",
            email: "anyEmail@email.com",
            password: "anyPassword"
        )
    }

    func makeInvalidData() -> Data {
        Data("invalid_data".utf8)
    }

    func makeURL() -> URL {
        URL(string: "any-url.com")!
    }
}
