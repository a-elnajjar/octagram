# Octagram

Octagram is a SwiftUI GitHub client that lets you search for users and inspect their profiles, followers, and following lists. The project targets iOS and consumes the public GitHub REST API.

## Requirements
- Xcode 15 or later
- iOS 17 SDK (minimum deployment target 17.0)
- A valid GitHub REST API base URL string (`https://api.github.com`) provided via the `GitHubAPIBaseURL` key in the app's `Info.plist`
- Active internet connection

## Getting Started
1. Clone the repository:
   ```bash
   git clone https://github.com/a-elnajjar/octagram.git
   cd octagram
   ```
2. Open `octagram.xcodeproj` in Xcode.
3. Ensure the `GitHubAPIBaseURL` entry exists in **Info.plist** (it should be set to `https://api.github.com`).
4. Run the **Octagram** scheme on the iOS Simulator or a physical device.

## Project Structure
- `OctagramApp.swift` – Application entry point.
- `ContentView.swift` – Hosts the root navigation stack.
- `Search/` – Search feature views and `SearchViewModel`.
- `UserProfile/` – User profile screen and `UserProfileViewModel`.
- `UsersList/` – Followers/following list UI and data fetching.
- `Models/` – API response models.
- `APIClient.swift` – Shared networking layer backed by `URLSession`.
he limitations above and include unit/UI tests where applicable.
