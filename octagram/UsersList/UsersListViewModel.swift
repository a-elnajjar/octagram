//
//  UsersListViewModel.swift
//  octagram
//
//  Created by Abdalla Elnajjar on 2025-04-05.
//

import Foundation

enum UserListingType: String, CaseIterable, Identifiable {
    case followers = "Followers"
    case following = "Following"

    var id: Self { self }

    var title: String { rawValue }
}

@MainActor
class UsersListViewModel: ObservableObject {
    // MARK: - variables

    @Published var users: [UserSummary] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private let apiClient: APIService

    init(apiClient: APIService) {
        self.apiClient = apiClient
    }

    // MARK: - methods

    func fetchUsers(username: String, type: UserListingType) async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        let path: String

        switch type {
        case .followers:
            path = GitHubAPIPath.user.rawValue + username + GitHubAPIPath.followers.rawValue
        case .following:
            path = GitHubAPIPath.user.rawValue + username + GitHubAPIPath.following.rawValue
        }

        do {
            let users = try await apiClient.fetch(path: path, as: [UserSummary].self)
            self.users = users
        } catch {
            self.users = []
            if let networkError = error as? NetworkError {
                errorMessage = networkError.errorDescription
            } else {
                errorMessage = error.localizedDescription
            }
        }
    }
}
