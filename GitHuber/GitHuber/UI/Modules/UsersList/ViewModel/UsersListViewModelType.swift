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
    var showLoading: ((_ show: Bool) -> Void)? { get set }
    var showOfflineView: ((_ show: Bool) -> Void)? { get set }

    // MARK: DataSources
    func userCellTap()
    func getUsersCount() -> Int
    func getCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UserCellType?

    // MARK: - SearchBar
    func searchBarTextDidBeginEditing()
    func searchBarTextDidChange(with query: String)
    func searchBarTextDidEndEditing()

}
