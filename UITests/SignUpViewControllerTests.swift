import XCTest
import UIKit
@testable import UI

final class SignUpViewControllerTests: XCTestCase {

    func test_loading_is_hidden_on_start() {
        let storyboard = UIStoryboard(name: "SignUpStoryboard", bundle: Bundle(for: SignUpViewController.self))
        let sut = storyboard.instantiateViewController(withIdentifier: "SignUpViewControllerID") as! SignUpViewController

        sut.loadViewIfNeeded()

        XCTAssertFalse(sut.loadingView.isAnimating)
    }
}
