import SwiftUI

enum AppTab: Hashable {
    case home, map, bookTicket, settings
}

struct MainTabView: View {
    @Environment(RoutesStore.self) private var routesStore
    @State private var selection: AppTab = .home

    var body: some View {
        TabView(selection: $selection) {
            RoutedStack { HomeView() }
                .tabItem { Label("Home", systemImage: "house") }
                .tag(AppTab.home)

            RoutedStack { RouteMapView() }
                .tabItem { Label("Map", systemImage: "map") }
                .tag(AppTab.map)

            RoutedStack { BookTicketView(preselectedRoute: nil) }
                .tabItem { Label("Book Ticket", systemImage: "ticket") }
                .tag(AppTab.bookTicket)

            RoutedStack { SettingsView() }
                .tabItem { Label("Settings", systemImage: "gearshape") }
                .tag(AppTab.settings)
        }
        .task { await routesStore.loadIfNeeded() }
    }
}
