//
//  AppDelegate.swift
//  GithubUser
//
//  Created by JaeBin on 2021/04/27.
//

import UIKit

@UIApplicationMain
class AppDelegate:  UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        
        let favoriteViewModel = FavoriteUserViewModel(useCase: LocalFavoriteGithubUserRepository())
        
        let githubUseCase = GithubUserRepository(network: DefaultNetwork(baseURL: "https://api.github.com"))
        
        let favoriteUserRouter = UserRouter(userDetailListner: favoriteViewModel)
        favoriteViewModel.router = favoriteUserRouter
        
        
        let searchUserRouter = UserRouter(userDetailListner: favoriteViewModel)
        let searchUserViewModel = SearchUsersViewModel(useCase: githubUseCase, listner: favoriteViewModel, router: searchUserRouter)
        let searchUserViewController = SearchUsersViewController(viewModel: searchUserViewModel)
        searchUserRouter.setController(controller: searchUserViewController)
        let searchUserIcon = UIImage(systemName: "magnifyingglass.circle.fill")
        let searchUserTabBarItem = UITabBarItem(title: "사용자 검색", image: searchUserIcon, selectedImage: searchUserIcon)
        searchUserViewController.tabBarItem = searchUserTabBarItem
        
        let favoriteViewController = FavoriteUserViewController(viewModel: favoriteViewModel)
        let favoriteIcon = UIImage(systemName: "star.circle.fill")
        let favoriteTabBarITem = UITabBarItem(title: "즐겨찾기", image: favoriteIcon, selectedImage: favoriteIcon)
        favoriteViewController.tabBarItem = favoriteTabBarITem
        favoriteUserRouter.setController(controller: favoriteViewController)
        
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window
        window.rootViewController = HomeTabbarController(viewControllers: [UINavigationController(rootViewController: searchUserViewController), UINavigationController(rootViewController:favoriteViewController)])
        window.makeKeyAndVisible()
        
        return true
    }
}

