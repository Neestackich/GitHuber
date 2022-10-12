//
//  UserProfileViewModelType.swift
//  GitHuber
//
//  Created by Vittcal Neestackich on 5.10.22.
//

import UIKit

protocol UserProfileViewModelType: ViewModelType {

    // MARK: Callbacks
    var showLoading: ((Bool) -> Void)? { get set }
    var showOfflineView: ((Bool) -> Void)? { get set }
    var updateAvatar: ((UIImage?) -> Void)? { get set }
    var updateTitle: ((String?) -> Void)? { get set }
    var updateNote: ((String?) -> Void)? { get set }
    var enableButton: ((Bool) -> Void)? { get set }
    var endEditing: (() -> Void)? { get set }

    // MARK: DataSource
    var bindData: ((UserProfileViewBindableData) -> Void)? { get set }

    // MARK: Actions
    func saveNoteButtonClick(text: String?)
    func textViewDidBeginEditing()

}
