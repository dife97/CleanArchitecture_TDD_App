import Presentation

class AlertViewSpy: AlertView {

    var emit: ((AlertViewModel) -> Void)?

    func showMessage(viewModel: AlertViewModel) {
        emit?(viewModel)
    }

    func observe(completion: @escaping (AlertViewModel) -> Void) {
        emit = completion
    }
}
