import Domain
import Presentation
import Validation
import UI

public final class SignUpComposer {

    public static func composeController(with addAccount: AddAccount) -> SignUpViewController {
        let controller = SignUpViewController.instantiate()
        let emailValidatorAdapter = EmailValidatorAdapter()
        let presenter = SignUpPresenter(
            alertView: WeakVarProxy(controller),
            emailValidator: emailValidatorAdapter,
            addAccount: addAccount,
            loadingView: WeakVarProxy(controller)
        )

        controller.signUp = presenter.signUp
        return controller
    }
}
