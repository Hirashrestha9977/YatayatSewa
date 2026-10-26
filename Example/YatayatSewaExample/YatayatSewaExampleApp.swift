import SwiftUI
import YatayatSewa

@main
struct YatayatSewaExampleApp: App {
    var body: some Scene {
        WindowGroup {
            YatayatSewaView(
                appId: "1",
                appAuthorizationId: "1",
                marketplaceId: "1"
            )
        }
    }
}
