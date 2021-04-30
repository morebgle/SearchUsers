//
//  CoreDataTests.swift
//  GithubUserTests
//
//  Created by JaeBin on 2021/04/29.
//

import XCTest
import RxBlocking
@testable import GithubUser


class CoreDataTests: XCTestCase {
    let database: FavoriteUserUseCase = LocalFavoriteGithubUserRepository()
    func testSearch() {
        
        let findItem = database.favoriteUser(id: 7)
        let item = try! findItem.toBlocking().first()
        let isFavorite = item??.isFavorite == true
        
        print(try! database.favoriteToggle(user: FavoriteUser(id: 1410106, name: "Apple", isFavorite: false, memo: nil, imageURL: nil)).toBlocking().first())
        let user = database.favoriteUsers(search: "")
        print(try! user.toBlocking().first())
        let isAllFavorite = try! user.toBlocking().first()?.contains(where: { $0.isFavorite == false }) == false
        XCTAssert(isAllFavorite)
        let aUser = database.favoriteUsers(search: "a")
        print(try! aUser.toBlocking().first())
        let isASearch = try! aUser.toBlocking().first()?.contains(where: { $0.name.contains("a") }) == true
        XCTAssert(isASearch)
        
        
        
    }
}
