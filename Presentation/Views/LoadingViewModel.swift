public struct LoadingViewModel: Equatable {
    let isLoading: Bool

    public init(
        isLoading: Bool
    ) {
        self.isLoading = isLoading
    }
}
