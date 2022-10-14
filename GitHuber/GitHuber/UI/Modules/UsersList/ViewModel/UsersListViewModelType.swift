//
//  UsersListViewModelType.swift
//  GitHuber
//
//  Created by Vittcal Neestackich on 5.10.22.
//

import UIKit

protocol UsersListViewModelType: ViewModelType {

    // MARK: Callbacks
    var reloadData: (() -> Void)? { get set }
    var endTableViewRefreshing: (() -> Void)? { get set }
    var showLoading: ((Bool) -> Void)? { get set }
    var showPaginationLoading: ((Bool) -> Void)? { get set }
    var showOfflineView: ((Bool) -> Void)? { get set }

    // MARK: Lifecycle
    func onViewWillAppear()

    // MARK: DataSources
    func userCellTap(didSelectRowAt indexPath: IndexPath)
    func getUsersCount() -> Int
    func getCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UserCellType?
    func paginate()

    // MARK: - SearchBar
    func searchBarTextDidBeginEditing()
    func searchBarTextDidChange(with query: String)
    func searchBarCancelButtonClicked()

}
