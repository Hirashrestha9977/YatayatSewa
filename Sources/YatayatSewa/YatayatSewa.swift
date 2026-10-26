import SwiftUI

/// Credentials and settings the host app passes in when it embeds the framework.
public struct YatayatSewaConfiguration: Sendable {
    public let appId: String
    public let appAuthorizationId: String
    public let marketplaceId: String
    public let baseURL: URL

    public static let defaultBaseURL = URL(string: "https://localhost8000.com/")!

    public init(
        appId: String,
        appAuthorizationId: String,
        marketplaceId: String,
        baseURL: URL = YatayatSewaConfiguration.defaultBaseURL
    ) {
        self.appId = appId
        self.appAuthorizationId = appAuthorizationId
        self.marketplaceId = marketplaceId
        self.baseURL = baseURL
    }
}

/// Entry point of the framework. Drop it into any SwiftUI hierarchy:
///
///     YatayatSewaView(appId: "…", appAuthorizationId: "…", marketplaceId: "…")
///
/// It opens on the Home tab, which lists every route the API returns.
public struct YatayatSewaView: View {
    @State private var routesStore: RoutesStore
    private let configuration: YatayatSewaConfiguration

    public init(
        appId: String,
        appAuthorizationId: String,
        marketplaceId: String,
        baseURL: URL = YatayatSewaConfiguration.defaultBaseURL
    ) {
        self.init(configuration: YatayatSewaConfiguration(
            appId: appId,
            appAuthorizationId: appAuthorizationId,
            marketplaceId: marketplaceId,
            baseURL: baseURL
        ))
    }

    public init(configuration: YatayatSewaConfiguration) {
        self.configuration = configuration
        _routesStore = State(initialValue: RoutesStore(apiClient: APIClient(configuration: configuration)))
    }

    public var body: some View {
        MainTabView()
            .environment(routesStore)
            .environment(\.yatayatConfiguration, configuration)
    }
}

private struct ConfigurationKey: EnvironmentKey {
    static let defaultValue = YatayatSewaConfiguration(appId: "", appAuthorizationId: "", marketplaceId: "")
}

extension EnvironmentValues {
    var yatayatConfiguration: YatayatSewaConfiguration {
        get { self[ConfigurationKey.self] }
        set { self[ConfigurationKey.self] = newValue }
    }
}
