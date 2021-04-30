//
//  GithubUserTableViewCell.swift
//  GithubUser
//
//  Created by JaeBin on 2021/04/29.
//

import UIKit
import RxSwift

class GithubUserTableViewCell: UITableViewCell {
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var memoLabel: UILabel!

    var disposeBag = DisposeBag()
    override func awakeFromNib() {
        super.awakeFromNib()
        favoriteButton.setImage(UIImage(systemName: "star"), for: .normal)
        favoriteButton.setImage(UIImage(systemName: "star.fill"), for: .selected)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    override func prepareForReuse() {
        disposeBag = DisposeBag()
    }
    
    func initCell(user: WrappedUser) {
        let name: String?
        let imageURLString: String?
        if let user = user.user {
            name = user.login
            imageURLString = user.avatarURL
        } else {
            name = user.favoriteUser?.name
            imageURLString = user.favoriteUser?.imageURL
            let isExistMemo = user.favoriteUser?.memo?.isEmpty != true
            memoLabel.text = user.favoriteUser?.memo
            memoLabel.isHidden = !isExistMemo
        }
        userNameLabel.text = name
        userImageView.sd_setImage(with: imageURLString?.toURL)
        favoriteButton.isSelected = user.favoriteUser?.isFavorite == true
    }
}
