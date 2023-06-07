import UIKit
import Presentation

final class SignUpViewController: UIViewController {

    @IBOutlet weak var loadingView: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
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
