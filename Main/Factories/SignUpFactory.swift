import Foundation
import Data
import Infra
import Presentation
import Validation
import UI

class SignUpFactory {

    static func makeController() -> SignUpViewController {
        let controller = SignUpViewController.instantiate()
        let emailValidatorAdapter = EmailValidatorAdapter()
        let url = URL(string: "https://clean-node-api.herokuapp.com/api/signup")!
        let urlSessionAdapter = URLSessionAdapter()
        let remoteAddAccount = RemoteAddAccount(
            url: url,
            httpClient: urlSessionAdapter
        )
        let presenter = SignUpPresenter(
            alertView: controller,
            emailValidator: emailValidatorAdapter,
            addAccount: remoteAddAccount,
            loadingView: controller
        )
        controller.signUp = presenter.signUp
        return controller
    }
}
