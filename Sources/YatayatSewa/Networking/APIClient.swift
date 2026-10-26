import Foundation

public enum APIError: LocalizedError {
    case invalidResponse
    case httpStatus(Int)
    case decoding(Error)
    case transport(Error)

    public var errorDescription: String? {
        switch self {
        case .invalidResponse: return "The server returned an invalid response."
        case .httpStatus(let code): return "The server responded with status \(code)."
        case .decoding(let error): return "Could not read the server data: \(error.localizedDescription)"
        case .transport(let error): return error.localizedDescription
        }
    }
}

/// URLSession-based client. Every request carries the app credentials as headers.
final class APIClient {
    enum Endpoint {
        case routes

        var path: String {
            switch self {
            case .routes: return "routes"
            }
        }
    }

    private let configuration: YatayatSewaConfiguration
    private let session: URLSession
    private let decoder = JSONDecoder()

    init(configuration: YatayatSewaConfiguration, session: URLSession = .shared) {
        self.configuration = configuration
        self.session = session
    }

    func fetchRoutes() async throws -> [BusRoute] {
        try await get(.routes)
    }

    func get<T: Decodable>(_ endpoint: Endpoint) async throws -> T {
        let request = makeRequest(endpoint, method: "GET")

        let data: Data
        let response: URLResponse
        do {
            (data, response) = try await session.data(for: request)
        } catch {
            throw APIError.transport(error)
        }

        guard let http = response as? HTTPURLResponse else { throw APIError.invalidResponse }
        guard (200..<300).contains(http.statusCode) else { throw APIError.httpStatus(http.statusCode) }

        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw APIError.decoding(error)
        }
    }

    func makeRequest(_ endpoint: Endpoint, method: String) -> URLRequest {
        var request = URLRequest(url: configuration.baseURL.appendingPathComponent(endpoint.path))
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue(configuration.appId, forHTTPHeaderField: "X-App-Id")
        request.setValue(configuration.marketplaceId, forHTTPHeaderField: "X-Marketplace-Id")
        request.setValue("Bearer \(configuration.appAuthorizationId)", forHTTPHeaderField: "Authorization")
        return request
    }
}
