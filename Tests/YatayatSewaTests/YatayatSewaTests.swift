import XCTest
@testable import YatayatSewa

final class BusRouteTests: XCTestCase {
    func testDecodesRoutesFromAPIJSON() throws {
        let json = """
        [{"id": "1", "startpoint": "Ratnapark", "endpoint": "Kalanki", "midpoints": "Sundhara, Tripureshwor"}]
        """.data(using: .utf8)!

        let routes = try JSONDecoder().decode([BusRoute].self, from: json)

        XCTAssertEqual(routes.count, 1)
        XCTAssertEqual(routes[0].startPoint, "Ratnapark")
        XCTAssertEqual(routes[0].midPointList, ["Sundhara", "Tripureshwor"])
        XCTAssertEqual(routes[0].allStops, ["Ratnapark", "Sundhara", "Tripureshwor", "Kalanki"])
    }

    func testEmptyMidPointsGiveNoStops() {
        let route = BusRoute(id: "2", startPoint: "A", endPoint: "B", midPoints: "")
        XCTAssertEqual(route.allStops, ["A", "B"])
    }
}

final class RouterTests: XCTestCase {
    func testPushAndPop() {
        let router = Router()
        let route = BusRoute(id: "1", startPoint: "A", endPoint: "B", midPoints: "")

        router.push(.routeDetail(route))
        router.push(.bookTicket(route))
        XCTAssertEqual(router.path.count, 2)

        router.pop()
        XCTAssertEqual(router.path.count, 1)

        router.popToRoot()
        XCTAssertEqual(router.path.count, 0)

        router.pop() // popping an empty stack is a no-op
        XCTAssertEqual(router.path.count, 0)
    }
}

final class APIClientTests: XCTestCase {
    func testRequestCarriesCredentials() {
        let client = APIClient(configuration: YatayatSewaConfiguration(
            appId: "app-1", appAuthorizationId: "secret", marketplaceId: "mkt-9"
        ))

        let request = client.makeRequest(.routes, method: "GET")

        XCTAssertEqual(request.url?.absoluteString, "https://localhost8000.com/routes")
        XCTAssertEqual(request.value(forHTTPHeaderField: "X-App-Id"), "app-1")
        XCTAssertEqual(request.value(forHTTPHeaderField: "X-Marketplace-Id"), "mkt-9")
        XCTAssertEqual(request.value(forHTTPHeaderField: "Authorization"), "Bearer secret")
    }
}
