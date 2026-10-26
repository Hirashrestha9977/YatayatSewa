import Foundation

/// A bus route as returned by the API.
///
/// Expected JSON: `{"id": "1", "startpoint": "Ratnapark", "endpoint": "Kalanki", "midpoints": "Sundhara, Tripureshwor"}`
public final class BusRoute: Codable, Identifiable, Hashable {
    public let id: String
    public let startPoint: String
    public let endPoint: String
    /// Stops between start and end, comma separated.
    public let midPoints: String

    public init(id: String, startPoint: String, endPoint: String, midPoints: String) {
        self.id = id
        self.startPoint = startPoint
        self.endPoint = endPoint
        self.midPoints = midPoints
    }

    enum CodingKeys: String, CodingKey {
        case id
        case startPoint = "startpoint"
        case endPoint = "endpoint"
        case midPoints = "midpoints"
    }

    /// `midPoints` split into individual stop names.
    public var midPointList: [String] {
        midPoints
            .split(separator: ",")
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty }
    }

    /// Every stop in travel order: start, mid points, end.
    public var allStops: [String] {
        [startPoint] + midPointList + [endPoint]
    }

    public var title: String { "\(startPoint) → \(endPoint)" }

    public static func == (lhs: BusRoute, rhs: BusRoute) -> Bool {
        lhs.id == rhs.id
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
