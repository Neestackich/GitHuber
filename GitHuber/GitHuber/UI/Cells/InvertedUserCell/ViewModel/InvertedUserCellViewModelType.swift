//
//  InvertedUserCellViewModelType.swift
//  GitHuber
//
//  Created by Vittcal Neestackich on 7.10.22.
//

import UIKit

protocol InvertedUserCellViewModelType: CellViewModelType {

    // MARK: Callbacks
    var showLoading: ((_ show: Bool) -> Void)? { get set }
    var updateAvatar: ((UIImage?) -> Void)? { get set }

}
