import Presentation

class AlertViewSpy: AlertView {

    private(set) var viewModel: AlertViewModel?
    func showMessage(viewModel: AlertViewModel) {
        self.viewModel = viewModel
    }
}
