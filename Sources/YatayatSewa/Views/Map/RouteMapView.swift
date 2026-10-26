import SwiftUI
import MapKit

/// Shows the selected route's stops on a map. The API only provides stop
/// names, so each stop is geocoded near the default map region.
struct RouteMapView: View {
    @Environment(RoutesStore.self) private var routesStore

    @State private var selectedRoute: BusRoute?
    @State private var stops: [GeocodedStop] = []
    @State private var isGeocoding = false
    @State private var cameraPosition: MapCameraPosition = .region(RouteMapView.defaultRegion)

    // Kathmandu valley.
    static let defaultRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 27.7172, longitude: 85.3240),
        span: MKCoordinateSpan(latitudeDelta: 0.15, longitudeDelta: 0.15)
    )

    var body: some View {
        Map(position: $cameraPosition) {
            ForEach(stops) { stop in
                Marker(stop.name, coordinate: stop.coordinate)
            }
            if stops.count > 1 {
                MapPolyline(coordinates: stops.map(\.coordinate))
                    .stroke(.blue, lineWidth: 4)
            }
        }
        .overlay(alignment: .top) {
            if isGeocoding {
                ProgressView("Locating stops…")
                    .padding(8)
                    .background(.regularMaterial, in: Capsule())
                    .padding(.top, 8)
            }
        }
        .safeAreaInset(edge: .bottom) { routePicker }
        .navigationTitle("Map")
        .navigationBarTitleDisplayMode(.inline)
        .task(id: selectedRoute) { await showStops(for: selectedRoute) }
    }

    private var routePicker: some View {
        Picker("Route", selection: $selectedRoute) {
            Text("Select a route").tag(BusRoute?.none)
            ForEach(routesStore.routes) { route in
                Text(route.title).tag(BusRoute?.some(route))
            }
        }
        .pickerStyle(.menu)
        .frame(maxWidth: .infinity)
        .padding()
        .background(.regularMaterial)
    }

    private func showStops(for route: BusRoute?) async {
        guard let route else {
            stops = []
            cameraPosition = .region(Self.defaultRegion)
            return
        }

        isGeocoding = true
        defer { isGeocoding = false }

        let hint = CLCircularRegion(center: Self.defaultRegion.center, radius: 50_000, identifier: "hint")
        var found: [GeocodedStop] = []
        for name in route.allStops {
            // CLGeocoder handles one request at a time, so geocode sequentially.
            let placemark = try? await CLGeocoder().geocodeAddressString(name, in: hint).first
            if Task.isCancelled { return }
            if let coordinate = placemark?.location?.coordinate {
                found.append(GeocodedStop(name: name, coordinate: coordinate))
            }
        }

        stops = found
        cameraPosition = .automatic
    }
}

private struct GeocodedStop: Identifiable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
}
