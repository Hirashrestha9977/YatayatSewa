import Foundation

/// Loads routes once and shares them with every tab.
@Observable
final class RoutesStore {
    enum State {
        case idle
        case loading
        case loaded([BusRoute])
        case failed(String)
    }

    private(set) var state: State = .idle
    private let apiClient: APIClient

    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }

    var routes: [BusRoute] {
        if case .loaded(let routes) = state { return routes }
        return []
    }

    @MainActor
    func loadIfNeeded() async {
        if case .idle = state { await reload() }
    }

    @MainActor
    func reload() async {
        state = .loading
        do {
            state = .loaded(try await apiClient.fetchRoutes())
        } catch {
            state = .failed(error.localizedDescription)
        }
    }
}
