//
//  NormalUserCell.swift
//  GitHuber
//
//  Created by Vittcal Neestackich on 6.10.22.
//

import UIKit

final class NormalUserCell: BaseCell<NormalUserCellViewModel> {

    // MARK: Properties

    @IBOutlet private weak var cellBackgroundView: UIView!
    @IBOutlet private weak var avatar: UIImageView!
    @IBOutlet private weak var username: UILabel!
    @IBOutlet private weak var details: UILabel!

    // MARK: Lifecycle

    override func awakeFromNib() {
        setupView()
    }

    override func prepareForReuse() {
        avatar.image = nil
        username.text = nil
        details.text = nil
    }

}

// MARK: - Public

extension NormalUserCell {

    func bindViewModel() {
        viewModel?.showLoading = { [weak self] show in
            self?.showLoading(show)
        }
        viewModel?.updateAvatar = { [weak self] image in
            self?.updateAvatar(image)
        }
    }

    func bindData(_ data: UserCellData) {
        username.text = data.username
        details.text = data.url
    }

}

// MARK: - Private

private extension NormalUserCell {

    private func updateAvatar(_ image: UIImage?) {
        avatar.image = image
    }

    private func showLoading(_ show: Bool) {
        
    }

    private func setupView() {
        semanticContentAttribute = .forceRightToLeft
        cellBackgroundView.layer.shadowRadius = 5
        cellBackgroundView.layer.shadowOpacity = 0.07
        cellBackgroundView.layer.masksToBounds = false
        cellBackgroundView.layer.shadowColor = UIColor.black.cgColor
        cellBackgroundView.layer.shadowOffset = CGSize(width: 0, height: 6)

        avatar.layer.cornerRadius = avatar.frame.size.width / 2.0
    }

}
