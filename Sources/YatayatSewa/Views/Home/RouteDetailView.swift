import SwiftUI

struct RouteDetailView: View {
    let route: BusRoute
    @Environment(Router.self) private var router

    var body: some View {
        List {
            Section("Route") {
                LabeledContent("Route ID", value: route.id)
                LabeledContent("From", value: route.startPoint)
                LabeledContent("To", value: route.endPoint)
            }

            Section("Stops") {
                ForEach(Array(route.allStops.enumerated()), id: \.offset) { index, stop in
                    Label(stop, systemImage: icon(for: index))
                }
            }

            Section {
                Button("Book a Ticket") { router.push(.bookTicket(route)) }
                Button("Back") { router.pop() }
            }
        }
        .navigationTitle(route.title)
        .navigationBarTitleDisplayMode(.inline)
    }

    private func icon(for index: Int) -> String {
        if index == 0 { return "circle.circle" }
        if index == route.allStops.count - 1 { return "mappin.circle.fill" }
        return "circle.fill"
    }
}
