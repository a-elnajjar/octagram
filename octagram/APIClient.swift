//
//  APIClient.swift
//  octagram
//
//  Created by Abdalla Elnajjar on 2025-04-05.
//

import Foundation

// network Errors
enum NetworkError: Error {
    case invalidURL
    case invalidStatusCode(Int)
    case networkError(Error)
    case decodingError(Error)
}

// GitHub API Paths
enum GitHubAPIPath: String {
    case searchUsers = "/search/users?q="
    case user = "/users/"
    case followers = "/followers"
    case following = "/following"
}

protocol APIService {
    func fetch<T: Decodable>(path: String, as type: T.Type) async throws -> T
}

//APIClient class
final class APIClient: APIService {
    // MARK: - variables

    private let session: URLSession
    private let baseURL: String

    // MARK: - init

    init(session: URLSession = .shared) {
        self.session = session
        guard let baseURL = Bundle.main.object(forInfoDictionaryKey: "GitHubAPIBaseURL") as? String,
              !baseURL.isEmpty
        else {
            fatalError("GitHubAPIBaseURL not found or empty in Info.plist")
        }

        self.baseURL = baseURL
    }

    // MARK: - methods

    func fetch<T: Decodable>(path: String, as _: T.Type) async throws -> T {
        guard let url = URL(string: baseURL + path) else {
            throw NetworkError.invalidURL
        }

        do {
            let (data, response) = try await session.data(from: url)
            guard let httpResponse = response as? HTTPURLResponse,
                  (200 ... 299).contains(httpResponse.statusCode)
            else {
                throw NetworkError.invalidStatusCode((response as? HTTPURLResponse)?.statusCode ?? -1)
            }
            return try JSONDecoder().decode(T.self, from: data)

        } catch let decodingError as DecodingError {
            throw NetworkError.decodingError(decodingError)
        } catch {
            throw NetworkError.networkError(error)
        }
    }
}
