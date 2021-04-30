//
//  SearchUserViewController.swift
//  GithubUser
//
//  Created by JaeBin on 2021/04/27.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import SDWebImage
protocol SearchUsersViewModelable: class {
    var searchedUsers: Observable<SearchUsers>  { get }
    var favoritedUsers: Observable<[FavoriteUser]> { get }
    func searchUser(search: String?)
    func nextPage(indexPathes: [IndexPath])
    func favorite(user: User?)
    func toDetail(user: WrappedUser)
}

class SearchUsersViewController: UIViewController {
    let tableView = UITableView()
    let viewModel: SearchUsersViewModelable
    init(viewModel: SearchUsersViewModelable) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
    }
    
    var disposeBag = DisposeBag()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        title = "사용자 검색"
        view = tableView
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.register(UINib(nibName: "GithubUserTableViewCell", bundle: nil), forCellReuseIdentifier: "GithubUserTableViewCell")
        let searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchController
        navigationItem.searchController?.searchBar.delegate = self
        navigationItem.searchController?.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController?.hidesNavigationBarDuringPresentation = false
        navigationItem.searchController?.searchBar.placeholder = "검색어를 입력하세요."
    }
    
    override func viewDidLoad() {
        
        
        let dataSource = RxTableViewSectionedAnimatedDataSource<WrappedUserSection>(configureCell: { (dataSource, tableView, indexPath, item) -> UITableViewCell in
            let cell = tableView.dequeueReusableCell(withIdentifier: "GithubUserTableViewCell", for: indexPath) as! GithubUserTableViewCell
            cell.initCell(user: item)
            cell.favoriteButton.rx.tap.bind { [weak self] _ in
                self?.viewModel.favorite(user: item.user!)
            }.disposed(by: cell.disposeBag)
            return cell
        })
        
        Observable.combineLatest(viewModel.searchedUsers, viewModel.favoritedUsers)
            .map({ searchUsers, favoriteUsers -> [WrappedUserSection] in
                let wrapUsers = searchUsers.items.map { user -> WrappedUser in
                    let favoriteUser = favoriteUsers.first { user.id == $0.id }
                    return WrappedUser(user: user, favoriteUser: favoriteUser)
                }
                return [WrappedUserSection(id: "",items: wrapUsers)]
            })
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        tableView.rx.prefetchRows
            .bind(onNext: viewModel.nextPage(indexPathes:))
            .disposed(by: disposeBag)
        tableView.rx.modelSelected(WrappedUser.self)
            .bind(onNext: viewModel.toDetail(user:)).disposed(by: disposeBag)
    }
}

extension SearchUsersViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        viewModel.searchUser(search: searchBar.text)
    }
}




