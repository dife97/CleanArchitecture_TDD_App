import XCTest
import Domain

extension XCTestCase {

    func makeAddAccountRequestModel() -> AddAccountModel.Request {
        AddAccountModel.Request(
            name: "Any Name",
            email: "anyEmail@email.com",
            password: "anyPassword",
            passwordConfirmation: "anyPassword"
        )
    }

    func makeAccountResponseModel() -> AddAccountModel.Response {
        AddAccountModel.Response(
            id: "anyID",
            name: "Any Name",
            email: "anyEmail@email.com",
            password: "anyPassword"
        )
    }

    func makeInvalidData() -> Data {
        Data("invalid_data".utf8)
    }

    func makeValidData() -> Data {
        Data("{\"name\":\"Diego\"}".utf8)
    }

    func makeEmptyData() -> Data {
        Data()
    }

    func makeURL() throws -> URL {
        try XCTUnwrap(URL(string: "any-url.com"))
    }

    func makeError() -> Error {
        NSError(domain: "any_error", code: 0)
    }

    func makeHTTPResponse(statusCode: Int = 200) throws -> HTTPURLResponse {
        try XCTUnwrap(
            HTTPURLResponse(
                url: try makeURL(),
                statusCode: statusCode,
                httpVersion: nil,
                headerFields: nil
            )
        )
    }
}
