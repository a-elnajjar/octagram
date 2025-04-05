//
//  UsersListViewModel.swift
//  octagram
//
//  Created by Abdalla Elnajjar on 2025-04-05.
//

import Foundation

enum UserListingType {
    case followers
    case following
}

@MainActor
class UsersListViewModel: ObservableObject {
    // MARK: - variables

    @Published var users: [UserSummary] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    private let apiClient = APIClient.shared

    // MARK: - methods

    func fetchUsers(username: String, typeOflesting: UserListingType) async {
        isLoading = true
        errorMessage = nil
        let path: String

        switch typeOflesting {
        case .followers:
            path = GitHubAPIPath.user.rawValue + username + GitHubAPIPath.followers.rawValue
        case .following:
            path = GitHubAPIPath.user.rawValue + username + GitHubAPIPath.following.rawValue
        }

        do {
            let users = try await apiClient.fetch(path: path, as: [UserSummary].self)
            self.users = users
        } catch {
            errorMessage = "Failed to load data"
            users = []
        }

        isLoading = false
    }
}
