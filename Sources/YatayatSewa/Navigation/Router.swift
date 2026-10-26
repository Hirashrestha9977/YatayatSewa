import SwiftUI

/// Screens that can be pushed onto a tab's navigation stack.
enum Destination: Hashable {
    case routeDetail(BusRoute)
    case bookTicket(BusRoute)
    case bookingConfirmation(Booking)
}

/// Owns one navigation stack and exposes push / pop operations.
/// Each tab gets its own Router so their stacks stay independent.
@Observable
final class Router {
    var path = NavigationPath()

    func push(_ destination: Destination) {
        path.append(destination)
    }

    func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }

    func pop(count: Int) {
        path.removeLast(min(count, path.count))
    }

    func popToRoot() {
        path.removeLast(path.count)
    }
}

/// Wraps a tab's root view in a NavigationStack driven by a Router.
struct RoutedStack<Root: View>: View {
    @State private var router = Router()
    @ViewBuilder let root: () -> Root

    var body: some View {
        NavigationStack(path: $router.path) {
            root()
                .navigationDestination(for: Destination.self) { destination in
                    switch destination {
                    case .routeDetail(let route):
                        RouteDetailView(route: route)
                    case .bookTicket(let route):
                        BookTicketView(preselectedRoute: route)
                    case .bookingConfirmation(let booking):
                        BookingConfirmationView(booking: booking)
                    }
                }
        }
        .environment(router)
    }
}
