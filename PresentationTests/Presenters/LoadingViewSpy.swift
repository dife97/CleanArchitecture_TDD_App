import Presentation

class LoadingViewSpy: LoadingView {

    private var emit: ((LoadingViewModel) -> Void)?
    func observe(completion: @escaping (LoadingViewModel) -> Void) {
        emit = completion
    }

    func display(viewModel: LoadingViewModel) {
        emit?(viewModel)
    }
}
