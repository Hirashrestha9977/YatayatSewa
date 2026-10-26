# YatayatSewa

A SwiftUI framework for browsing bus routes, viewing them on a map, and booking tickets. Embed it in any iOS app with one view.

## Features

- **Home**: every route the API returns, with pull to refresh and a detail screen for each route
- **Map**: the stops of a selected route drawn on a map (Kathmandu by default)
- **Book Ticket**: choose a route, stops, date and passengers, then see a confirmation
- **Settings**: app preferences and the IDs the app was set up with

Each tab has its own navigation stack, controlled by a `Router` with `push`, `pop`, `pop(count:)` and `popToRoot`.

## Requirements

- iOS 17+
- Xcode 15+ (Swift 5.9)

## Installation

Add the package with Swift Package Manager.

In Xcode: **File ▸ Add Package Dependencies…** and enter:

```
https://github.com/Hirashrestha9977/YatayatSewa.git
```

Or in `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/Hirashrestha9977/YatayatSewa.git", branch: "main")
]
```

## Usage

```swift
import SwiftUI
import YatayatSewa

@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            YatayatSewaView(
                appId: "YOUR_APP_ID",
                appAuthorizationId: "YOUR_AUTHORIZATION_ID",
                marketplaceId: "YOUR_MARKETPLACE_ID"
            )
        }
    }
}
```

The default server is `https://localhost8000.com/`. To use a different one, pass `baseURL`:

```swift
YatayatSewaView(
    appId: "1",
    appAuthorizationId: "1",
    marketplaceId: "1",
    baseURL: URL(string: "http://localhost:8000/")!
)
```

A plain `http` URL needs an App Transport Security exception in the host app's `Info.plist`.

## API

The framework sends the routes request as:

```
GET {baseURL}/routes
Accept: application/json
X-App-Id: <appId>
X-Marketplace-Id: <marketplaceId>
Authorization: Bearer <appAuthorizationId>
```

and expects a JSON array of routes:

```json
[
  {
    "id": "1",
    "startpoint": "Ratnapark",
    "endpoint": "Kalanki",
    "midpoints": "Sundhara, Tripureshwor"
  }
]
```

All fields are strings. `midpoints` is a comma-separated list of the stops between the start and the end.

Booking happens only in the app for now. No booking request is sent to the server.

## Sample app

`Example/YatayatSewaExample.xcodeproj` is a small iOS app that embeds the framework with `"1"` for every ID. Open it, choose an iPhone simulator, and press ⌘R.

## Project structure

```
Sources/YatayatSewa/
├── YatayatSewa.swift      Public entry view and configuration
├── Models/                BusRoute, Booking
├── Networking/            URLSession API client
├── Navigation/            Router (push / pop)
├── Stores/                Shared routes data
└── Views/                 Home, Map, Booking, Settings
Tests/YatayatSewaTests/    Unit tests
Example/                   Sample iOS app
```

## Running the tests

```sh
xcodebuild test -scheme YatayatSewa -destination 'platform=iOS Simulator,name=iPhone 15'
```
