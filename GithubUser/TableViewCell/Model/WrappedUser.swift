//
//  WrapUser.swift
//  GithubUser
//
//  Created by JaeBin on 2021/04/30.
//

import Foundation
import RxDataSources
struct WrappedUser: IdentifiableType, Equatable {
    let user: User?
    let favoriteUser: FavoriteUser?
    
    init(user: User?, favoriteUser: FavoriteUser?) {
        self.user = user
        self.favoriteUser = favoriteUser
    }
    
    var identity: Int { return self.user?.id ?? favoriteUser!.id }
    
    static func == (lhs: WrappedUser, rhs: WrappedUser) -> Bool {
        lhs.user?.login == rhs.user?.login && lhs.favoriteUser?.isFavorite == rhs.favoriteUser?.isFavorite && lhs.favoriteUser?.memo == rhs.favoriteUser?.memo
    }
}
