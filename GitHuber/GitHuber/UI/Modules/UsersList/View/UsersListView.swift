//
//  UsersListView.swift
//  GitHuber
//
//  Created by Vittcal Neestackich on 5.10.22.
//

import UIKit

final class UsersListView: BaseView<UsersListViewModel> {

    // MARK: Properties

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

    private lazy var tableViewFooter: UIView = {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 64))
        footerView.backgroundColor = .clear

        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.color = .gray
        activityIndicator.style = .medium
        footerView.addSubview(activityIndicator)
        activityIndicator.center = footerView.center
        activityIndicator.startAnimating()

        return footerView
    }()

    private struct Constants {
        static let searchBarTintColor = "SearchBarTint"
        static let grayBackground = "GrayBackground"
        static let offlineViewBackground = "OfflineViewBackground"
        static let labelsTint = "OfflineLabelTextColor"
        static let offlineViewText = "Offline mode enabled"
        static let navBarTitle = "GitHub Users"
        static let whiteBackground = "WhiteBackground"
    }

    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        bindViewModel()
        viewModel?.onViewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        viewModel?.onViewWillAppear()
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
        self.title = Constants.navBarTitle
        navigationController?.navigationBar.tintColor = UIColor(named: Constants.searchBarTintColor)
        navigationItem.searchController = searchController
        navigationItem.searchController?.searchBar.searchTextField.backgroundColor = UIColor(named: Constants.whiteBackground)
        navigationItem.hidesSearchBarWhenScrolling = true
        navigationController?.navigationBar.prefersLargeTitles = true
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
        viewModel?.searchBarTextDidBeginEditing()
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        viewModel?.searchBarTextDidEndEditing()
    }

}

// MARK: - UITableViewDataSource, UITableViewDelegate

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
        viewModel?.userCellTap(didSelectRowAt: indexPath)
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let usersCount = viewModel?.getUsersCount() else {
            return
        }

        tableView.tableFooterView = tableViewFooter

        if indexPath.row == usersCount - 1 {
            tableView.tableFooterView = nil
            viewModel?.paginate()
        }
    }

}
