//
//  UserDetailViewModel.swift
//  GithubUser
//
//  Created by JaeBin on 2021/04/28.
//

import Foundation
import RxSwift
import RxRelay

protocol UserDetailListner: class {
    func modifyMemo(user: FavoriteUser)
}

class UserDetailViewModel {
    var _favoriteUser = BehaviorRelay<FavoriteUser?>(value: nil)
    var _user = BehaviorRelay<User?>(value: nil)
    weak var listner: UserDetailListner?
    let githubUseCase: GithubUserUseCase
    let favoriteUserUseCase: FavoriteUserUseCase
    let userName: String
    var disposeBag = DisposeBag()
    init(userName: String, githubUseCase: GithubUserUseCase, favoriteUserUseCase: FavoriteUserUseCase, listner: UserDetailListner) {
        self.userName = userName
        self.githubUseCase = githubUseCase
        self.favoriteUserUseCase = favoriteUserUseCase
        self.listner = listner
    }
    
    
    
    
}

extension UserDetailViewModel: UserDetailViewModelable {
    var favoriteUser: Observable<FavoriteUser?> {
        return _favoriteUser.asObservable()
    }
    var user: Observable<User> {
        return _user.asObservable().flatMap { Observable.from(optional: $0) }
    }
    func save(memo: String) {
        guard let user = _user.value else { return }
        let favoriteUser = FavoriteUser(id: user.id, name: user.login, isFavorite: _favoriteUser.value?.isFavorite == true,
                                        memo: memo, imageURL: user.avatarURL)
        favoriteUserUseCase.save(user: favoriteUser).do(onNext: self.listner?.modifyMemo(user:)).bind(to: self._favoriteUser)
            .disposed(by: disposeBag)
        
    }
    
    func load() {
        let share = githubUseCase.userDetail(userName: userName).share()
            share.bind(to: _user).disposed(by: disposeBag)
        share.flatMap {
            self.favoriteUserUseCase.favoriteUser(id: $0.id)
        }
        .bind(to: _favoriteUser).disposed(by: disposeBag)
    }
}
