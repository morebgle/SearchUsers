//
//  UserDetailViewController.swift
//  GithubUser
//
//  Created by JaeBin on 2021/04/28.
//

import UIKit
import RxSwift
import RxCocoa

protocol UserDetailViewModelable: class {
    var favoriteUser: Observable<FavoriteUser?> { get }
    var user: Observable<User> { get }
    func save(memo: String)
    func load()
}

protocol UserDetailRoutable: class {
    func toDetail(userName: String)
}

class UserDetailViewController: UIViewController {
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var blogLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var memoTextView: UITextView!
    @IBOutlet weak var saveButton: UIButton!
    
    var userBinding: Binder<User> {
        return Binder(self) { viewController, user in
            viewController.profileImageView.sd_setImage(with: user.avatarURL?.toURL)
            viewController.nameLabel.text = user.login
            if let email = user.email?.emptyNil {
                viewController.emailLabel.isHidden = false
                viewController.emailLabel.text = "email: " + email
            }
            if let blog = user.blog?.emptyNil {
                viewController.blogLabel.isHidden = false
                viewController.blogLabel.text = "blog: " + blog
            }
            if let location = user.location?.emptyNil {
                viewController.locationLabel.isHidden = false
                viewController.locationLabel.text = "location: " + location
            }
            if let company = user.company?.emptyNil {
                viewController.companyLabel.isHidden = false
                viewController.companyLabel.text = "company: " + company
            }
        }
    }
    var disposeBag = DisposeBag()
    var viewModel: UserDetailViewModelable!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.user.bind(to: userBinding).disposed(by: disposeBag)
        let memo = viewModel.favoriteUser.map { $0?.memo }
        memo.bind(to: memoTextView.rx.text).disposed(by: disposeBag)
        Observable.combineLatest(memo,memoTextView.rx.text.map({ $0
        })).map { memo, textViewText -> Bool in
            return memo?.emptyNil == textViewText?.emptyNil
        }.bind(to: saveButton.rx.isHidden).disposed(by: disposeBag)
        saveButton.rx.tap.withLatestFrom(memoTextView.rx.text)
            .flatMap({ Observable.from(optional: $0) })
            .do(onNext: { [weak self] _ in
                self?.memoTextView.endEditing(true)
            })
            .bind(onNext: viewModel.save(memo:))
            .disposed(by: disposeBag)
        
        viewModel.load()
        // Do any additional setup after loading the view.
    }
}
