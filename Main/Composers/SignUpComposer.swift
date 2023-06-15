import Domain
import UI

public final class SignUpComposer {

    public static func composeController(with addAccount: AddAccount) -> SignUpViewController {
        ControllerFactory.makeSignUp(addAccount: addAccount)
    }
}
