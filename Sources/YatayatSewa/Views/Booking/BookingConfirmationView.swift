import SwiftUI

struct BookingConfirmationView: View {
    let booking: Booking
    @Environment(Router.self) private var router

    var body: some View {
        List {
            Section {
                Label("Ticket booked", systemImage: "checkmark.seal.fill")
                    .font(.title3.bold())
                    .foregroundStyle(.green)
            }

            Section("Details") {
                LabeledContent("Route", value: booking.route.title)
                LabeledContent("From", value: booking.from)
                LabeledContent("To", value: booking.to)
                LabeledContent("Date", value: booking.date.formatted(date: .abbreviated, time: .shortened))
                LabeledContent("Passengers", value: "\(booking.passengers)")
                LabeledContent("Name", value: booking.passengerName)
            }

            Section {
                Button("Done") { router.popToRoot() }
            }
        }
        .navigationTitle("Confirmation")
        .navigationBarBackButtonHidden()
    }
}
