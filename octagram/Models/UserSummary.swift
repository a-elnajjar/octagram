//
//  UserSummary.swift
//  octagram
//
//  Created by Abdalla Elnajjar on 2025-04-05.
//

import Foundation

//SearchResult will hodle the search result data from searchUsers endpoint 
struct SearchResult: Codable {
	let items: [UserSummary]
}

struct UserSummary: Codable, Identifiable {
	let id: Int
	let login: String
	let avatarURL: String?
	
	enum CodingKeys: String, CodingKey {
		case id
		case login
		case avatarURL = "avatar_url"
	}
}
