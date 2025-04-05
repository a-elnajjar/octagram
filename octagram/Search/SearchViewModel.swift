//
//  SearchViewModel.swift
//  octagram
//
//  Created by Abdalla Elnajjar on 2025-04-05.
//

import Foundation

@MainActor
class SearchViewModel: ObservableObject {
    @Published var query: String = ""
    @Published private(set) var results: [UserSummary] = []
    @Published private(set) var isLoading = false
    @Published var errorMessage: String?

    private let apiClient = APIClient.shared

    // Search for users
    func searchUsers() {
        // if Query string empty  clear the the result
        guard !query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            results = []
            return
        }

        Task {
            await performSearch()
        }
    }

    // search logic
    private func performSearch() async {
        isLoading = true
        errorMessage = nil

        let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let path = GitHubAPIPath.searchUsers.rawValue + encodedQuery

        do {
            let response = try await apiClient.fetch(path: path, as: SearchResult.self)
            results = response.items
        } catch {
            results = []
            errorMessage = "Something went wrong. Please try again."
        }

        isLoading = false
    }
}
