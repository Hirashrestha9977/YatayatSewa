import SwiftUI

struct SettingsView: View {
    @Environment(\.yatayatConfiguration) private var configuration
    @Environment(RoutesStore.self) private var routesStore

    @AppStorage("yatayat.notificationsEnabled") private var notificationsEnabled = true
    @AppStorage("yatayat.useMetricUnits") private var useMetricUnits = true

    var body: some View {
        Form {
            Section("General") {
                Toggle("Notifications", isOn: $notificationsEnabled)
                Toggle("Metric units", isOn: $useMetricUnits)
            }

            Section("Data") {
                Button("Refresh Routes") { Task { await routesStore.reload() } }
            }

            Section("App") {
                LabeledContent("App ID", value: configuration.appId)
                LabeledContent("Marketplace ID", value: configuration.marketplaceId)
                LabeledContent("Authorization", value: masked(configuration.appAuthorizationId))
                LabeledContent("Server", value: configuration.baseURL.absoluteString)
            }
        }
        .navigationTitle("Settings")
    }

    private func masked(_ value: String) -> String {
        guard value.count > 4 else { return String(repeating: "•", count: value.count) }
        return String(repeating: "•", count: value.count - 4) + value.suffix(4)
    }
}
