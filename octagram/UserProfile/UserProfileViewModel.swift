//
//  UserProfileViewModel.swift
//  octagram
//
//  Created by Abdalla Elnajjar on 2025-04-05.
//

import Foundation

@MainActor
class UserProfileViewModel: ObservableObject {
    // MARK: - variables

    @Published var user: User?
    @Published var isLoading = false
    @Published var errorMessage: String?
    private let apiClient: APIService

    init(apiClient: APIService) {
        self.apiClient = apiClient
    }

    // MARK: - methods

    func fetchUserProfile(_ username: String) async {
        isLoading = true
        defer { isLoading = false }

        do {
            let path = GitHubAPIPath.user.rawValue + username
            let result = try await apiClient.fetch(path: path, as: User.self)
            user = result
        } catch {
            errorMessage = "Failed to load user profile."
        }
    }
}
