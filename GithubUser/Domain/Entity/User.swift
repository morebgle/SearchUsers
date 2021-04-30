//
//  User.swift
//  GithubUser
//
//  Created by JaeBin on 2021/04/28.
//

import Foundation

class User: Decodable {
    let login: String
    let id: Int
    let nodeID: String
    let avatarURL: String?
    let company: String?
    let blog, location: String?
    let email: String?

    enum CodingKeys: String, CodingKey {
        case login, id
        case nodeID = "node_id"
        case avatarURL = "avatar_url"
        case company, blog, location, email
    }
}
