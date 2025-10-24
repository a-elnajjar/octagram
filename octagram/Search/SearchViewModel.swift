//
//  SearchViewModel.swift
//  octagram
//
//  Created by Abdalla Elnajjar on 2025-04-05.
//

import Foundation

@MainActor
class SearchViewModel: ObservableObject {
    // MARK: - variables

    @Published var query: String = ""
    @Published private(set) var results: [UserSummary] = []
    @Published private(set) var isLoading = false
    @Published var errorMessage: String?

    private let apiClient: APIService
    private var searchTask: Task<Void, Never>?
    private var lastExecutedQuery: String?

    init(apiClient: APIService) {
        self.apiClient = apiClient
    }

    deinit {
        searchTask?.cancel()
    }

    // Search for users
    func searchUsers() {
        let trimmedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)
        searchTask?.cancel()

        guard !trimmedQuery.isEmpty else {
            results = []
            isLoading = false
            lastExecutedQuery = nil
            return
        }

        guard trimmedQuery != lastExecutedQuery else { return }

        searchTask = Task { [weak self] in
            do {
                try await Task.sleep(nanoseconds: 300_000_000)
                guard !Task.isCancelled else { return }
                await self?.performSearch(for: trimmedQuery)
            } catch {
                // Ignore cancellation errors
            }
        }
    }

    // MARK: - methods

    // search logic
    private func performSearch(for query: String) async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let path = GitHubAPIPath.searchUsers.rawValue + encodedQuery

        do {
            let response = try await apiClient.fetch(path: path, as: SearchResult.self)
            results = response.items
            lastExecutedQuery = query
        } catch {
            results = []
            lastExecutedQuery = nil
            if let networkError = error as? NetworkError {
                errorMessage = networkError.errorDescription
            } else {
                errorMessage = error.localizedDescription
            }
        }
    }
}
