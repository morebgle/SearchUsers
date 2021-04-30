//
//  GithubUserRepository.swift
//  GithubUser
//
//  Created by JaeBin on 2021/04/28.
//

import Foundation
import RxSwift
class GithubUserRepository: GithubUserUseCase {
    private let network: DefaultNetwork
    init(network: DefaultNetwork) {
        self.network = network
    }
    func searchUsers(search: String?, page: Int) -> Observable<SearchUsers> {
        guard let search = search, !search.isEmpty else { return .error(NSError(domain: "", code: 1, userInfo: [NSLocalizedDescriptionKey:"검색어를 입력해주세요."])) }
        return network.getObject(url: "/search/users", parameter: ["q":search,"per_page":100,"page":page])
    }
    
    func userDetail(userName: String) -> Observable<User> {
        guard !userName.isEmpty else { return .error(NSError(domain: "", code: 2, userInfo: [NSLocalizedDescriptionKey:"유저 네임을 입력해주세요."])) }
        return network.getObject(url: "/users/\(userName)")
    }
}
