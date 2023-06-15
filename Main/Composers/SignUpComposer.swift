import Domain
import UI

public final class SignUpComposer {

    static func composeController(with addAccount: AddAccount) -> SignUpViewController {
        ControllerFactory.makeSignUp(addAccount: addAccount)
    }
}
