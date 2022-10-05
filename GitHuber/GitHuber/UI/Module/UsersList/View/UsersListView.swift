//
//  UsersListView.swift
//  GitHuber
//
//  Created by Vittcal Neestackich on 5.10.22.
//

import UIKit

final class UsersListView: BaseView<UsersListViewModel> {

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel?.onViewDidLoad()
    }

}
