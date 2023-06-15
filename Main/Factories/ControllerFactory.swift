import Domain
import Presentation
import Validation
import UI

final class ControllerFactory {

    static func makeSignUp(addAccount: AddAccount) -> SignUpViewController {
        let controller = SignUpViewController.instantiate()
        let emailValidatorAdapter = EmailValidatorAdapter()
        let presenter = SignUpPresenter(
            alertView: controller,
            emailValidator: emailValidatorAdapter,
            addAccount: addAccount,
            loadingView: controller
        )

        controller.signUp = presenter.signUp

        return controller
    }
}
