//
//  GithubUseCase.swift
//  GithubUser
//
//  Created by JaeBin on 2021/04/28.
//

import Foundation
import RxSwift
protocol GithubUserUseCase {
    func searchUsers(search: String?, page: Int) -> Observable<SearchUsers>
    func userDetail(userName: String) -> Observable<User>
}
