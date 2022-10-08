//
//  BaseCell.swift
//  GitHuber
//
//  Created by Vittcal Neestackich on 6.10.22.
//

import UIKit

class BaseCell<ViewModel: CellViewModelType>: UITableViewCell, UserCellType {

    var viewModel: ViewModel?

    private var type: CellType?

}
