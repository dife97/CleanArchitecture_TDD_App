import XCTest
import UIKit
@testable import UI

final class SignUpViewControllerTests: XCTestCase {

    func test_loading_is_hidden_on_start() {
        let storyboard = UIStoryboard(name: "SignUp", bundle: Bundle(for: SignUpViewController.self))
        let sut = storyboard.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController

        sut.loadViewIfNeeded()

        XCTAssertFalse(sut.loadingView.isAnimating)
    }
}
