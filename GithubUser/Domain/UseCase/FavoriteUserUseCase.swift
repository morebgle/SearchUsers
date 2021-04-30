//
//  FavoriteUserUseCase.swift
//  GithubUser
//
//  Created by JaeBin on 2021/04/28.
//

import Foundation
import RxSwift
protocol FavoriteUserUseCase {
    func favoriteUsers(search: String?) -> Observable<[FavoriteUser]>
    func favoriteUser(id: Int) -> Observable<FavoriteUser?>
    func favoriteToggle(user: FavoriteUser?) -> Observable<FavoriteUser?>
    func favoriteUser(user: User) -> Observable<FavoriteUser?>
    func save(user: FavoriteUser) -> Observable<FavoriteUser>
    func favorite(id: Int) -> Observable<FavoriteUser>
}
