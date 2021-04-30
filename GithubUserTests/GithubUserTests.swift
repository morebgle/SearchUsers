//
//  GithubUserTests.swift
//  GithubUserTests
//
//  Created by JaeBin on 2021/04/27.
//

import XCTest
import RxBlocking
@testable import GithubUser

import CoreData

class GithubUserTests: XCTestCase {
    let githubRepository = GithubUserRepository(network: DefaultNetwork(baseURL: "https://api.github.com"))
    func testRepository_searchGithubUsers() {
        
        let item = githubRepository.searchUsers(search: "sosohan", page: 1).toBlocking()
        XCTAssert(try item.first()?.items.count == 12)
        let empty = githubRepository.searchUsers(search: "", page: 1).toBlocking()
        XCTAssertThrowsError(try empty.first()) { (error) in
            XCTAssert("검색어를 입력해주세요." == error.localizedDescription)
        }
        
    }
    
    func testRepository_userDetail() {
        let item = githubRepository.userDetail(userName: "sosohan-app").toBlocking()
        XCTAssert(try item.first()?.login == "sosohan-app")
        let empty = githubRepository.userDetail(userName: "").toBlocking()
        XCTAssertThrowsError(try empty.first()) { (error) in
            XCTAssert("유저 네임을 입력해주세요." == error.localizedDescription)
        }
    }
    


}
