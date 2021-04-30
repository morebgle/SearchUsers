//
//  FavoriteUser.swift
//  GithubUser
//
//  Created by JaeBin on 2021/04/29.
//

import Foundation

struct FavoriteUser {
    let id: Int
    let name: String
    let isFavorite: Bool
    let memo: String?
    let imageURL: String?
}
extension FavoriteUser {
    func change(memo: String) -> FavoriteUser {
        return FavoriteUser(id: id, name: name, isFavorite: isFavorite, memo: memo, imageURL: imageURL)
    }
    
    func toggle() -> FavoriteUser {
        return FavoriteUser(id: id, name: name, isFavorite: !isFavorite, memo: memo, imageURL: imageURL)
    }
}

extension CDFavoriteUser {
    var toFavoriteUser: FavoriteUser {
        return FavoriteUser(id: Int(id), name: name!, isFavorite: isFavorite, memo: memo, imageURL: imageURL)
    }
}
