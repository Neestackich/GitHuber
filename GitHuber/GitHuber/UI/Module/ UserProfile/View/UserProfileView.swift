//
//  UserProfileView.swift
//  GitHuber
//
//  Created by Vittcal Neestackich on 5.10.22.
//

import Foundation

final class UserProfileView: BaseView<UserProfileViewModel> {

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel?.onViewDidLoad()
    }

}
