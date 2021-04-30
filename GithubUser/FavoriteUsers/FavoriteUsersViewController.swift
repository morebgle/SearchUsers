//
//  FavoriteUserViewController.swift
//  GithubUser
//
//  Created by JaeBin on 2021/04/28.
//

import UIKit
import RxSwift
import RxDataSources
protocol FavoriteUserViewModelable {
    var searchedFavoriteUsers: Observable<[FavoriteUser]> { get }
    func unFavorite(user: FavoriteUser?)
    func searchFavoriteUsers(search: String?)
    func toDetail(user: WrappedUser)
}

class FavoriteUserViewController: UIViewController {
    let tableView = UITableView()
    
    let viewModel: FavoriteUserViewModelable
    var disposeBag = DisposeBag()
    
    init(viewModel: FavoriteUserViewModelable) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        title = "즐겨찾기"
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
        super.viewDidLoad()

        let dataSource = RxTableViewSectionedAnimatedDataSource<WrappedUserSection>(configureCell: { (dataSource, tableView, indexPath, item) -> UITableViewCell in
            let cell = tableView.dequeueReusableCell(withIdentifier: "GithubUserTableViewCell", for: indexPath) as! GithubUserTableViewCell
            cell.initCell(user: item)
            cell.favoriteButton.rx.tap.bind { [weak self] _ in
                self?.viewModel.unFavorite(user: item.favoriteUser)
            }.disposed(by: cell.disposeBag)
            return cell
        },
        titleForHeaderInSection: { dataSource, index -> String in
            return dataSource.sectionModels[index].id
        })
        
        viewModel.searchedFavoriteUsers
            .map { favoriteUsers -> [WrappedUserSection] in
                let users = favoriteUsers.map { WrappedUser(user: nil, favoriteUser: $0) }
                let dictionary = Dictionary(grouping: users, by: { String($0.favoriteUser!.name.first!).uppercased() })
                let keys = dictionary.keys.sorted()
                return keys.map{ WrappedUserSection(id: $0, items: dictionary[$0]!) }
            }
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        
        tableView.rx.modelSelected(WrappedUser.self)
            .bind(onNext: viewModel.toDetail(user:)).disposed(by: disposeBag)
        
        viewModel.searchFavoriteUsers(search: nil)
    }


}


extension FavoriteUserViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        viewModel.searchFavoriteUsers(search: searchBar.text)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            viewModel.searchFavoriteUsers(search: nil)
        }
    }
}
