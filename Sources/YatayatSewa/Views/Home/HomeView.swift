import SwiftUI

struct HomeView: View {
    @Environment(RoutesStore.self) private var routesStore
    @Environment(Router.self) private var router

    var body: some View {
        content
            .navigationTitle("Bus Routes")
            .refreshable { await routesStore.reload() }
    }

    @ViewBuilder
    private var content: some View {
        switch routesStore.state {
        case .idle, .loading:
            ProgressView("Loading routes…")
                .frame(maxWidth: .infinity, maxHeight: .infinity)

        case .failed(let message):
            ContentUnavailableView {
                Label("Couldn't load routes", systemImage: "exclamationmark.triangle")
            } description: {
                Text(message)
            } actions: {
                Button("Try Again") { Task { await routesStore.reload() } }
            }

        case .loaded(let routes) where routes.isEmpty:
            ContentUnavailableView("No routes yet", systemImage: "bus")

        case .loaded(let routes):
            List(routes) { route in
                Button {
                    router.push(.routeDetail(route))
                } label: {
                    RouteRow(route: route)
                }
                .tint(.primary)
            }
        }
    }
}

struct RouteRow: View {
    let route: BusRoute

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(route.title)
                .font(.headline)
            if !route.midPointList.isEmpty {
                Text("via \(route.midPointList.joined(separator: ", "))")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }
        }
        .padding(.vertical, 4)
    }
}
