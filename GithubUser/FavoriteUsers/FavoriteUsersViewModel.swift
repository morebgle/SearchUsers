//
//  FavoriteUserViewModel.swift
//  GithubUser
//
//  Created by JaeBin on 2021/04/28.
//

import Foundation
import RxSwift
import RxRelay
class FavoriteUserViewModel {
    
    
    private let _favoriteUsers = BehaviorRelay<[FavoriteUser]>(value: [])
    private let _searchedFavoriteUsers = BehaviorRelay<[FavoriteUser]>(value: [])
    private let useCase: FavoriteUserUseCase
    
    private var disposeBag = DisposeBag()
    private var search: String?
    var router: UserRouter!
    init(useCase: FavoriteUserUseCase) {
        self.useCase = useCase
    }
    

    private func favoriteToggle(user: FavoriteUser?) {
        let toggle = useCase.favoriteToggle(user: user).share()
        toggle
            .withLatestFrom(_favoriteUsers) { (toggle, favoriteUsers) -> [FavoriteUser] in
                if let toggle = toggle, toggle.isFavorite {
                    return favoriteUsers + [toggle]
                } else {
                    return favoriteUsers.filter { $0.id != toggle?.id }
                }
            }
            .bind(to: _favoriteUsers).disposed(by: disposeBag)
        toggle.filter({ $0?.isFavorite == false })
            .withLatestFrom(_searchedFavoriteUsers) { (unFavoriteUser, searchedFavoriteUsers) -> [FavoriteUser] in
                searchedFavoriteUsers.filter { $0.id != unFavoriteUser?.id }
            }
            .bind(to: _searchedFavoriteUsers).disposed(by: disposeBag)
        toggle.filter({ $0?.isFavorite == true })
            .map({ _ in })
            .flatMap { self.useCase.favoriteUsers(search: self.search) }
            .bind(to: _searchedFavoriteUsers).disposed(by: disposeBag)
    }
}

extension FavoriteUserViewModel: FavoriteUserViewModelable {
    var searchedFavoriteUsers: Observable<[FavoriteUser]> {
        return _searchedFavoriteUsers.asObservable()
    }
    func searchFavoriteUsers(search: String?) {
        self.search = search
        useCase.favoriteUsers(search: search).bind(to: _searchedFavoriteUsers).disposed(by: disposeBag)
    }
    
    func unFavorite(user: FavoriteUser?) {
        favoriteToggle(user: user)
    }
    
    func toDetail(user: WrappedUser) {
        router.toDetail(userName: user.favoriteUser!.name)
    }
}

extension FavoriteUserViewModel: SearchUserListener {
    var favoriteUsers: Observable<[FavoriteUser]> {
        return _favoriteUsers.asObservable()
    }
    
    func allFavoriteUsers() {
        useCase.favoriteUsers(search: "").bind(to: _favoriteUsers).disposed(by: disposeBag)
    }
    
    func favoriteUser(user: User) {
        useCase.favoriteUser(user: user).bind(onNext: favoriteToggle(user:)).disposed(by: disposeBag)
    }
}

extension FavoriteUserViewModel: UserDetailListner {
    func modifyMemo(user: FavoriteUser) {
        var searchUsers = _searchedFavoriteUsers.value
        if let index = searchUsers.firstIndex(where: { $0.id == user.id }) {
            searchUsers[index] = user
            _searchedFavoriteUsers.accept(searchUsers)
        }
    }
}
