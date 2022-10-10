//
//  CellViewModelType.swift
//  GitHuber
//
//  Created by Vittcal Neestackich on 6.10.22.
//

import UIKit

protocol CellViewModelType: AnyObject {

    // MARK: Lifecycle
    func onAwakeFromNib()

    // MARK: DataSource
    func getCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UserCellType?

}
