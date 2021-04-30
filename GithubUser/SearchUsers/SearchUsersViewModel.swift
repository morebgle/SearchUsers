//
//  SearchUserViewModel.swift
//  GithubUser
//
//  Created by JaeBin on 2021/04/27.
//

import Foundation
import RxSwift
import RxRelay

protocol SearchUserListener: class {
    var favoriteUsers: Observable<[FavoriteUser]> { get }
    func allFavoriteUsers()
    func favoriteUser(user: User)
}

class SearchUsersViewModel {
    private let _searchedUsers = BehaviorRelay<SearchUsers?>(value: nil)
    private let useCase: GithubUserUseCase
    private var listener: SearchUserListener!
    private var router: UserRouter
    init(useCase: GithubUserUseCase, listner: SearchUserListener, router: UserRouter) {
        self.useCase = useCase
        self.listener = listner
        self.router = router
    }
    private var searchDisposeBag = DisposeBag()
    private var page = 1
    private var search: String?
    private var isLoading: Bool = false
    private var isEndPage: Bool = false
    
}
extension SearchUsersViewModel: SearchUsersViewModelable {

    
    var searchedUsers: Observable<SearchUsers> {
        return _searchedUsers.asObservable().flatMap({ Observable.from(optional: $0) })
    }
    var favoritedUsers: Observable<[FavoriteUser]> {
        return listener.favoriteUsers
    }
    func searchUser(search: String?) {
        if !isLoading {
            page = 1
            self.search = search
            searchDisposeBag = DisposeBag()
            self.isLoading = true
            useCase.searchUsers(search: self.search, page: self.page)
                .do(onNext: { [weak self] value in
                    self?.isEndPage = value.items.count < 100
                }, onDispose: { [weak self] in
                    self?.isLoading = false
                })
                .bind(to: _searchedUsers).disposed(by: searchDisposeBag)
            
        }
        listener.allFavoriteUsers()
    }
    func nextPage(indexPathes: [IndexPath]) {
        guard let value = _searchedUsers.value else { return }
        guard indexPathes.contains(where: { $0.row >= value.items.count - 1 }) else { return }
        
        if !isLoading || !isEndPage {
            searchDisposeBag = DisposeBag()
            self.page += 1
            self.isLoading = true
            useCase.searchUsers(search: self.search, page: self.page).withLatestFrom(self._searchedUsers, resultSelector: { (newUsers, oldUsers) -> SearchUsers in
                guard let tempOldUsers = oldUsers?.items
                        .filter({ oldUser in !newUsers.items.contains { newUser -> Bool in newUser.id == oldUser.id } }) else { return newUsers }
                return SearchUsers(totalCount: newUsers.totalCount, items: tempOldUsers + newUsers.items)
                
            })
            .do(onNext: { [weak self] value in
                self?.isEndPage = value.items.count < 100
                
            }, onDispose: { [weak self] in
                self?.isLoading = false
            })
            .catchErrorJustReturn(.init(totalCount: 0, items: []))
            .bind(to: _searchedUsers).disposed(by: searchDisposeBag)
            
        }
    }
    func favorite(user: User?) {
        guard let user = user else { return }
        listener.favoriteUser(user: user)
    }
    
    func toDetail(user: WrappedUser) {
        router.toDetail(userName: user.user!.login)
    }
}


class CoreDataModel {
    let favoriteUsers = BehaviorRelay<[FavoriteUser]>(value: [])
    let searchedFavoriteUsers = BehaviorRelay<[FavoriteUser]>(value: [])
    let useCase: FavoriteUserUseCase
    init() {
        useCase = LocalFavoriteGithubUserRepository()
    }
    
    var allFavoriteUsersDisposeBag = DisposeBag()
    
    func allFavoriteUsers() {
        self.useCase.favoriteUsers(search: "").bind(to: favoriteUsers).disposed(by: allFavoriteUsersDisposeBag)
    }
    
    func favorite(user: FavoriteUser) {
        self.useCase.favoriteToggle(user: user).flatMap { _ in self.useCase.favoriteUsers(search: "") }.bind(to: favoriteUsers).disposed(by: allFavoriteUsersDisposeBag)
    }
}















