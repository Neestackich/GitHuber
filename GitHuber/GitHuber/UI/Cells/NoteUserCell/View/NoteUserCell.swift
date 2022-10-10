//
//  NoteUserCell.swift
//  GitHuber
//
//  Created by Vittcal Neestackich on 6.10.22.
//

import UIKit

final class NoteUserCell: BaseCell<NoteUserCellViewModel> {

    // MARK: Properties

    @IBOutlet private weak var cellBackgroundView: UIView!
    @IBOutlet private weak var avatar: UIImageView!
    @IBOutlet private weak var username: UILabel!
    @IBOutlet private weak var details: UILabel!

    private struct Constants {
        static let personImage = "person.circle"
        static let normalBackgroundColor = "WhiteBackground"
        static let seenBackgroundColor = "SeenUserCellBackground"
    }

    // MARK: Lifecycle

    override func awakeFromNib() {
        setupView()
    }

    override func prepareForReuse() {
        avatar.image = nil
        username.text = nil
        details.text = nil
        cellBackgroundView.backgroundColor = UIColor(named: Constants.normalBackgroundColor)
    }

}

// MARK: - Public

extension NoteUserCell {

    func bindViewModel() {
        viewModel?.showLoading = { [weak self] show in
            self?.showLoading(show)
        }
        viewModel?.updateAvatar = { [weak self] image in
            self?.updateAvatar(image)
        }
        viewModel?.onAwakeFromNib()
    }

    func bindData(_ data: UserCellBindableData) {
        username.text = data.username
        details.text = data.url

        if data.isSeen {
            cellBackgroundView.backgroundColor = UIColor(named: Constants.seenBackgroundColor)
        }
    }

}

// MARK: - Private

private extension NoteUserCell {

    private func updateAvatar(_ image: UIImage?) {
        avatar.image = image
    }

    private func showLoading(_ show: Bool) {
        if show {
            avatar.image = UIImage(systemName: Constants.personImage)
        } else {
            avatar.image = nil
        }
    }

    private func setupView() {
        semanticContentAttribute = .forceRightToLeft
        cellBackgroundView.layer.shadowRadius = 5
        cellBackgroundView.layer.shadowOpacity = 0.07
        cellBackgroundView.layer.masksToBounds = false
        cellBackgroundView.layer.shadowColor = UIColor.black.cgColor
        cellBackgroundView.layer.shadowOffset = CGSize(width: 0, height: 6)

        avatar.layer.cornerRadius = avatar.bounds.size.height / 2
    }

}
