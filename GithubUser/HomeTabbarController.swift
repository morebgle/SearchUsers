//
//  HomeTabbarController.swift
//  GithubUser
//
//  Created by JaeBin on 2021/04/28.
//

import UIKit

class HomeTabbarController: UITabBarController {
    
    init(viewControllers: [UIViewController]) {
        super.init(nibName: nil, bundle: nil)
        self.viewControllers = viewControllers
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
//        delegate = self
        // Do any additional setup after loading the view.
    }
}


//extension HomeTabbarController: UITabBarControllerDelegate {
//
//}
