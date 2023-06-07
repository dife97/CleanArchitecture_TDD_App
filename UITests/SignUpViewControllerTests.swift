import XCTest
import UIKit
import Presentation
@testable import UI

final class SignUpViewControllerTests: XCTestCase {

    func test_loading_is_hidden_on_start() {
        let storyboard = UIStoryboard(name: "SignUp", bundle: Bundle(for: SignUpViewController.self))
        let sut = storyboard.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController

        sut.loadView()

        XCTAssertFalse(sut.loadingView.isAnimating)
    }

    func test_sut_implements_loadingView() {
        let storyboard = UIStoryboard(name: "SignUp", bundle: Bundle(for: SignUpViewController.self))
        let sut = storyboard.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController

        XCTAssertNotNil(sut as LoadingView)
    }
}
