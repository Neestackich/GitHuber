//
//  UsersListView.swift
//  GitHuber
//
//  Created by Vittcal Neestackich on 5.10.22.
//

import UIKit

final class UsersListView: BaseView<UsersListViewModel> {

    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        searchController.searchBar.sizeToFit()
        searchController.searchBar.searchBarStyle = .prominent

        return searchController
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none

        tableView.register(UINib(nibName: "NormalUserCell", bundle: nil), forCellReuseIdentifier: "normalUserCell")
        tableView.register(UINib(nibName: "NoteUserCell", bundle: nil), forCellReuseIdentifier: "noteUserCell")
        tableView.register(UINib(nibName: "InvertedUserCell", bundle: nil), forCellReuseIdentifier: "invertedUserCell")

        return tableView
    }()

    private lazy var offlineView: UIView = {
        let offlineView = UIView()
        offlineView.backgroundColor = UIColor(named: Constants.offlineViewBackground)
        offlineView.isHidden = true

        return offlineView
    }()

    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.color = .gray
        activityIndicator.style = .large
        activityIndicator.hidesWhenStopped = true

        return activityIndicator
    }()

    private struct Constants {
        static let searchBarTintColor = "SearchBarTint"
        static let grayBackground = "GrayBackground"
        static let offlineViewBackground = "OfflineViewBackground"
        static let labelsTint = "OfflineLabelTextColor"
        static let offlineViewText = "Offline mode enabled"
    }

    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        bindViewModel()

        viewModel?.onViewDidLoad()
    }

    private func bindViewModel() {
        viewModel?.reloadData = { [weak self] in
            self?.tableView.reloadData()
        }
        viewModel?.endTableViewRefreshing = { [weak self] in
            self?.tableView.refreshControl?.endRefreshing()
        }
        viewModel?.showLoading = { [weak self] show in
            self?.showLoading(show)
        }
        viewModel?.showOfflineView = { [weak self] show in
            self?.showOfflineView(show)
        }
    }

}

// MARK: - Private

private extension UsersListView {

    private func setup() {
        setupView()
        setUpNavigationBar()
        setupTableView()
        setupActivityIndicator()
        setupOfflineView()
    }

    private func setUpNavigationBar() {
        navigationController?.navigationBar.tintColor = UIColor(named: Constants.searchBarTintColor)
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
    }

    private func setupView() {
        view.backgroundColor = UIColor(named: Constants.grayBackground)
    }

    private func setupTableView() {
        view.addSubview(tableView)
        tableView.backgroundColor = UIColor(named: Constants.grayBackground)

        tableView.translatesAutoresizingMaskIntoConstraints = false

        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }

    private func setupActivityIndicator() {
        view.addSubview(activityIndicator)

        activityIndicator.translatesAutoresizingMaskIntoConstraints = false

        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }

    private func setupOfflineView() {
        view.addSubview(offlineView)

        offlineView.translatesAutoresizingMaskIntoConstraints = false
        offlineView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        offlineView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        offlineView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        offlineView.heightAnchor.constraint(equalToConstant: 64).isActive = true

        let label = UILabel()
        label.text = Constants.offlineViewText
        label.textColor = UIColor(named: Constants.labelsTint)
        offlineView.addSubview(label)

        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerXAnchor.constraint(equalTo: offlineView.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: offlineView.centerYAnchor).isActive = true
    }

    private func showLoading(_ show: Bool) {
        if show {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }

    private func showOfflineView(_ show: Bool) {
        offlineView.isHidden = !show
    }

}

// MARK: - UISearchBarDelegate

extension UsersListView: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel?.searchBarTextDidChange(with: searchText)
    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        // viewModel?.disablePagination()
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        viewModel?.searchBarTextDidEndEditing()
    }

}

//// MARK: - DiffableDataSource
//
//extension UsersListView {
//
//    private func makeDataSource(tableView: UITableView) -> UITableViewDiffableDataSource<Section, NormalUser> {
//        return UITableViewDiffableDataSource<Section, NormalUser>(tableView: tableView, cellProvider: { (tableView, indexPath, user) -> UITableViewCell? in
//            let cell = tableView.dequeueReusableCell(withIdentifier: "", for: indexPath)
//
//            return cell
//        })
//    }
//
//    private func updateTable(with models: [MenuItemViewModel], animate: Bool = false) {
//        var snapshot = MenuItemsDataSourceSnapshot()
//        snapshot.appendSections(Section.allCases)
//        snapshot.appendItems(models, toSection: .items)
//        dataSource?.apply(snapshot, animatingDifferences: animate)
//    }
//
//    private func provideCell(tableView: UITableView, indexPath: IndexPath, model: NormalUser) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(MenuItemCell.self, for: indexPath)
//        cell.configure(with: model.name, color: model.color)
//        return cell
//    }
//
//}

// MAR: - UITableViewDataSource, UITableViewDelegate

extension UsersListView: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.getUsersCount() ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = viewModel?.getCell(tableView, cellForRowAt: indexPath) else {
            return UITableViewCell()
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel?.userCellTap()
    }

}
