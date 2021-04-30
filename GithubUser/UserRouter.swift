//
//  SearchUserRouter.swift
//  GithubUser
//
//  Created by JaeBin on 2021/04/30.
//

import UIKit

class UserRouter: UserDetailRoutable {
    private weak var listner: UserDetailListner!
    private weak var controller: UIViewController?
    init(userDetailListner: UserDetailListner) {
        self.listner = userDetailListner
    }
    
    func toDetail(userName: String) {
        let userDetailViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "UserDetailViewController") as! UserDetailViewController
        userDetailViewController.viewModel = UserDetailViewModel(userName: userName, githubUseCase: GithubUserRepository(network: DefaultNetwork(baseURL: "https://api.github.com")), favoriteUserUseCase: LocalFavoriteGithubUserRepository(), listner: listner)
        self.controller?.navigationController?.pushViewController(userDetailViewController, animated: true)
    }
    
    func setController(controller: UIViewController) {
        self.controller = controller
    }
}
