//
//  UserProfileViewModelDelegate.swift
//  GitHuber
//
//  Created by Vittcal Neestackich on 9.10.22.
//

import Foundation

protocol UserProfileViewModelDelegate: AnyObject {
    func reloadUserCell(at indexPath: IndexPath)
}
