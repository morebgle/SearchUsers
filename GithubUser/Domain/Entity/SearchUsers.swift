//
//  SearchUsers.swift
//  GithubUser
//
//  Created by JaeBin on 2021/04/28.
//

import Foundation
struct SearchUsers: Decodable {
    let totalCount: Int
    let items: [User]

    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case items
    }
}
