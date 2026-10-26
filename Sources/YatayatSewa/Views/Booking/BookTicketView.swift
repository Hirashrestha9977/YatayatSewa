import SwiftUI

struct BookTicketView: View {
    @Environment(RoutesStore.self) private var routesStore
    @Environment(Router.self) private var router

    @State private var route: BusRoute?
    @State private var from = ""
    @State private var to = ""
    @State private var date = Date()
    @State private var passengers = 1
    @State private var passengerName = ""

    init(preselectedRoute: BusRoute?) {
        _route = State(initialValue: preselectedRoute)
        _from = State(initialValue: preselectedRoute?.startPoint ?? "")
        _to = State(initialValue: preselectedRoute?.endPoint ?? "")
    }

    var body: some View {
        Form {
            Section("Route") {
                Picker("Route", selection: $route) {
                    Text("Select a route").tag(BusRoute?.none)
                    ForEach(routesStore.routes) { route in
                        Text(route.title).tag(BusRoute?.some(route))
                    }
                }

                if let route {
                    Picker("From", selection: $from) {
                        ForEach(route.allStops, id: \.self) { Text($0).tag($0) }
                    }
                    Picker("To", selection: $to) {
                        ForEach(route.allStops, id: \.self) { Text($0).tag($0) }
                    }
                }
            }

            Section("Trip") {
                DatePicker("Date", selection: $date, in: Date()..., displayedComponents: [.date, .hourAndMinute])
                Stepper("Passengers: \(passengers)", value: $passengers, in: 1...10)
                TextField("Passenger name", text: $passengerName)
                    .textContentType(.name)
            }

            Section {
                Button("Book Ticket", action: book)
                    .frame(maxWidth: .infinity)
                    .disabled(!canBook)
            } footer: {
                if route != nil && from == to {
                    Text("Pick different start and end stops.")
                }
            }
        }
        .navigationTitle("Book Ticket")
        .onChange(of: route) { _, newRoute in
            from = newRoute?.startPoint ?? ""
            to = newRoute?.endPoint ?? ""
        }
    }

    private var canBook: Bool {
        route != nil
            && !from.isEmpty && !to.isEmpty && from != to
            && !passengerName.trimmingCharacters(in: .whitespaces).isEmpty
    }

    private func book() {
        guard let route else { return }
        router.push(.bookingConfirmation(Booking(
            route: route,
            from: from,
            to: to,
            date: date,
            passengers: passengers,
            passengerName: passengerName.trimmingCharacters(in: .whitespaces)
        )))
    }
}
