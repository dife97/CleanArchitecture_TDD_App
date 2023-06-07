import XCTest
import UIKit
import Presentation
@testable import UI

final class SignUpViewControllerTests: XCTestCase {

    func test_loading_is_hidden_on_start() {
        XCTAssertFalse(makeSUT().loadingView.isAnimating)
    }

    func test_sut_implements_loadingView() {
        XCTAssertNotNil(makeSUT() as LoadingView)
    }

    func test_sut_implements_alertView() {
        XCTAssertNotNil(makeSUT() as AlertView)
    }
}

extension SignUpViewControllerTests {

    private func makeSUT() -> SignUpViewController {
        let storyboard = UIStoryboard(name: "SignUp", bundle: Bundle(for: SignUpViewController.self))
        let sut = storyboard.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController

        sut.loadView()

        return sut
    }
}
