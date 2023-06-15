import UIKit
import Presentation

public final class SignUpViewController: UIViewController, Storyboarded {

    public var signUp: ((SignUpViewModel) -> Void)?

    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordConfirmationTextField: UITextField!

    public override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    private func configureUI() {
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        saveButton.layer.cornerRadius = 8
        hideKeyboardOnTap()
    }

    @objc private func saveButtonTapped() {
        let viewModel = SignUpViewModel(
            name: nameTextField.text,
            email: emailTextField.text,
            password: passwordTextField.text,
            passwordConfirmation: passwordConfirmationTextField.text
        )
        signUp?(viewModel)
    }
}

extension SignUpViewController: LoadingView {

    public func display(viewModel: LoadingViewModel) {
        if viewModel.isLoading {
            view.isUserInteractionEnabled = false
            loadingView.startAnimating()
        } else {
            view.isUserInteractionEnabled = true
            loadingView.stopAnimating()
        }
    }
}

extension SignUpViewController: AlertView {

    public func showMessage(viewModel: AlertViewModel) {
        let alert = UIAlertController(
            title: viewModel.title,
            message: viewModel.message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(
            title: "Ok",
            style: .default
        ))
        present(alert, animated: true)
    }
}
