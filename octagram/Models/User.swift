//
//  User.swift
//  octagram
//
//  Created by Abdalla Elnajjar on 2025-04-05.
//

import Foundation

struct User: Codable, Identifiable {
    let id: Int
    let login: String
    let name: String?
    let avatarURL: String
    let description: String?
    let followers: Int
    let following: Int

    enum CodingKeys: String, CodingKey {
        case id
        case login
        case name
        case avatarURL = "avatar_url"
        case description = "bio"
        case followers
        case following
    }
}
