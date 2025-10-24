//
//  APIClient.swift
//  octagram
//
//  Created by Abdalla Elnajjar on 2025-04-05.
//

import Foundation

// network Errors
enum NetworkError: Error {
    case invalidConfiguration
    case invalidURL
    case invalidStatusCode(Int)
    case networkError(Error)
    case decodingError(Error)
}

extension NetworkError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidConfiguration:
            return "The app is not configured correctly."
        case .invalidURL:
            return "We couldn't build a valid request."
        case .invalidStatusCode(let status):
            return "Received an unexpected response (status code: \(status))."
        case .networkError(let error):
            return error.localizedDescription
        case .decodingError:
            return "We couldn't read the server response."
        }
    }
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
    private let baseURL: URL
    private let decoder: JSONDecoder

    // MARK: - init

    init(baseURL: URL, session: URLSession = .shared, decoder: JSONDecoder = .githubAPI) {
        self.baseURL = baseURL
        self.session = session
        self.decoder = decoder
    }

    static func makeDefault(session: URLSession = .shared, bundle: Bundle = .main) -> APIClient {
        if let baseURLString = bundle.object(forInfoDictionaryKey: "GitHubAPIBaseURL") as? String,
           let url = URL(string: baseURLString),
           !baseURLString.isEmpty {
            return APIClient(baseURL: url, session: session)
        }

        #if DEBUG
            print("[APIClient] GitHubAPIBaseURL missing in Info.plist. Falling back to https://api.github.com")
        #endif
        let fallbackURL = URL(string: "https://api.github.com")!
        return APIClient(baseURL: fallbackURL, session: session)
    }

    // MARK: - methods

    func fetch<T: Decodable>(path: String, as _: T.Type) async throws -> T {
        guard let url = URL(string: path, relativeTo: baseURL) else {
            throw NetworkError.invalidURL
        }

        do {
            var request = URLRequest(url: url)
            request.setValue("application/vnd.github+json", forHTTPHeaderField: "Accept")
            let (data, response) = try await session.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse,
                  (200 ... 299).contains(httpResponse.statusCode)
            else {
                throw NetworkError.invalidStatusCode((response as? HTTPURLResponse)?.statusCode ?? -1)
            }
            return try decoder.decode(T.self, from: data)

        } catch let decodingError as DecodingError {
            throw NetworkError.decodingError(decodingError)
        } catch let networkError as URLError {
            throw NetworkError.networkError(networkError)
        } catch {
            throw NetworkError.networkError(error)
        }
    }
}

#if DEBUG
extension APIClient {
    static func previewClient() -> APIClient {
        APIClient(baseURL: URL(string: "https://api.github.com")!)
    }
}
#endif

private extension JSONDecoder {
    static let githubAPI: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .customISO8601
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
}

private extension JSONDecoder.DateDecodingStrategy {
    static let customISO8601: JSONDecoder.DateDecodingStrategy = .custom { decoder in
        let container = try decoder.singleValueContainer()
        let dateString = try container.decode(String.self)

        if let date = ISO8601DateFormatter.githubWithFractionalSeconds.date(from: dateString) {
            return date
        }

        if let fallbackDate = ISO8601DateFormatter.githubDefault.date(from: dateString) {
            return fallbackDate
        }

        throw DecodingError.dataCorrupted(
            DecodingError.Context(
                codingPath: decoder.codingPath,
                debugDescription: "Invalid ISO8601 date: \(dateString)"
            )
        )
    }
}

private extension ISO8601DateFormatter {
    static let githubWithFractionalSeconds: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter
    }()

    static let githubDefault: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]
        return formatter
    }()
}
