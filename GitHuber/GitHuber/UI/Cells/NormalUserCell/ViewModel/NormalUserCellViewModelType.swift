//
//  NormalUserCellViewModelType.swift
//  GitHuber
//
//  Created by Vittcal Neestackich on 6.10.22.
//

import UIKit

protocol NormalUserCellViewModelType: CellViewModelType {

    // MARK: Callbacks
    var showLoading: ((_ show: Bool) -> Void)? { get set }
    var updateAvatar: ((UIImage?) -> Void)? { get set }

}
