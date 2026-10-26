import Foundation

struct Booking: Hashable, Identifiable {
    let id = UUID()
    let route: BusRoute
    let from: String
    let to: String
    let date: Date
    let passengers: Int
    let passengerName: String
}
