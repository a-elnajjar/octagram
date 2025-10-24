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

## Running Tests
This project does not include automated tests. Add unit tests under the `octagramTests` target (not yet created) to cover:
- Network layer decoding and error handling.
- View model behavior for loading, success, and failure states.

## Linting & Style
No linting tools are configured. Consider integrating **SwiftLint** or **SwiftFormat** for consistent style.

## Known Limitations & Follow-Up Work
- No request throttling or cancellation when typing in the search bar, which can generate excessive API calls.
- Followers/following navigation always defaults to the "Following" tab and does not deep-link to the tapped segment.
- Alert presentation in `SearchView` uses an immutable binding and will not dismiss correctly once shown.
- Networking base URL relies on a fatal error if the Info.plist key is missing instead of failing gracefully.
- API responses are decoded with a default `JSONDecoder` and do not customize date/strategy handling if GitHub responses change.

Contributions should address the limitations above and include unit/UI tests where applicable.
