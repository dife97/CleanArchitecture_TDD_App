import UIKit
import Presentation

final class SignUpViewController: UIViewController {

    var signUp: ((SignUpViewModel) -> Void)?

    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    @IBOutlet weak var saveButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
    }

    @objc private func saveButtonTapped() {
        signUp?(SignUpViewModel(name: nil, email: nil, password: nil, passwordConfirmation: nil))
    }
}

extension SignUpViewController: LoadingView {

    func display(viewModel: LoadingViewModel) {
        if viewModel.isLoading {
            loadingView.startAnimating()
        } else {
            loadingView.stopAnimating()
        }
    }
}

extension SignUpViewController: AlertView {

    func showMessage(viewModel: AlertViewModel) {

    }
}
