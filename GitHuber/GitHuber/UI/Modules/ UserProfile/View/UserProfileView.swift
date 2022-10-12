//
//  UserProfileView.swift
//  GitHuber
//
//  Created by Vittcal Neestackich on 5.10.22.
//

import UIKit

final class UserProfileView: BaseView<UserProfileViewModel> {

    // MARK: - Properties

    @IBOutlet private weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet private weak var avatarBackgroundView: UIView!
    @IBOutlet private weak var avatarImageView: UIImageView!
    @IBOutlet private weak var noteBackgroundView: UIView!
    @IBOutlet private weak var userNoteTextView: UITextView!
    @IBOutlet private weak var addNoteButton: UIButton!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var companyLabel: UILabel!
    @IBOutlet private weak var blogLabel: UILabel!
    @IBOutlet private weak var followersLabel: UILabel!
    @IBOutlet private weak var followingLabel: UILabel!
    @IBOutlet private weak var offlineView: UIView!
    @IBOutlet private weak var offlineViewText: UILabel!

    private struct Constants {
        static let navigationBarTint = "NavigationBarTint"
        static let grayBackground = "GrayBackground"
        static let offlineViewBackground = "OfflineViewBackground"
        static let labelsTint = "OfflineLabelTextColor"
        static let offlineViewText = "Offline mode enabled"
        static let textViewColor = "TextViewColor"
    }

    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        bindViewModel()
        viewModel?.onViewDidLoad()
    }

}

// MARK: - Actions

private extension UserProfileView {

    @IBAction private func saveNoteButtonClick(_ sender: Any) {
        viewModel?.saveNoteButtonClick(text: userNoteTextView.text)
    }

}

// MARK: - Private

private extension UserProfileView {

    private func setup() {
        setupView()
        setUpNavigationBar()
        setupNoteTextView()
        setupNoteBackgroundView()
        setupAvatar()
        setupAvatarBackgroundView()
        setupButton()
        setupOfflineView()
    }

    private func setupView() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboard)))
    }

    private func setUpNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = UIColor(named: Constants.navigationBarTint)
    }

    private func setupNoteTextView() {
        userNoteTextView.textColor = UIColor(named: Constants.textViewColor)
    }

    private func setupNoteBackgroundView() {
        noteBackgroundView.layer.shadowRadius = 5
        noteBackgroundView.layer.shadowOpacity = 0.07
        noteBackgroundView.layer.masksToBounds = false
        noteBackgroundView.layer.shadowColor = UIColor.black.cgColor
        noteBackgroundView.semanticContentAttribute = .forceRightToLeft
        noteBackgroundView.layer.shadowOffset = CGSize(width: 0, height: 6)
    }

    private func setupAvatar() {
        avatarImageView.layer.cornerRadius = avatarImageView.frame.size.width / 2.0
    }

    private func setupAvatarBackgroundView() {
        avatarBackgroundView.layer.shadowRadius = 5
        avatarBackgroundView.layer.shadowOpacity = 0.07
        avatarBackgroundView.layer.masksToBounds = false
        avatarBackgroundView.layer.shadowColor = UIColor.black.cgColor
        avatarBackgroundView.semanticContentAttribute = .forceRightToLeft
        avatarBackgroundView.layer.shadowOffset = CGSize(width: 0, height: 6)
    }

    private func setupButton() {
        addNoteButton.layer.shadowRadius = 4
        addNoteButton.layer.shadowOpacity = 0.25
        addNoteButton.layer.masksToBounds = false
        addNoteButton.layer.shadowColor = UIColor.black.cgColor
        addNoteButton.semanticContentAttribute = .forceRightToLeft
        addNoteButton.layer.shadowOffset = CGSize(width: 0, height: 4)
        addNoteButton.layer.cornerRadius = addNoteButton.frame.size.height / 2.0
    }

    private func setupOfflineView() {
        offlineView.isHidden = true
    }

    private func bindData(_ data: UserProfileViewBindableData) {
        nameLabel.text = "\(data.name)"
        companyLabel.text = "Company: \(data.company)"
        blogLabel.text = "Blog: \(data.blog)"
        followersLabel.text = "Followers: \(data.followers)"
        followingLabel.text = "Following: \(data.following)"
        userNoteTextView.text = data.note
        addNoteButton.isEnabled = data.enableButton
    }

    private func bindViewModel() {
        viewModel?.bindData = { [weak self] data in
            self?.bindData(data)
        }
        viewModel?.showOfflineView = { [weak self] show in
            self?.showOfflineView(show)
        }
        viewModel?.updateAvatar = { [weak self] image in
            self?.updateAvatar(image)
        }
        viewModel?.updateTitle = { [weak self] text in
            self?.updateTitle(text)
        }
        viewModel?.showLoading = { [weak self] show in
            self?.showLoading(show)
        }
        viewModel?.updateNote = { [weak self] text in
            self?.updateNote(text)
        }
        viewModel?.enableButton = { [weak self] enable in
            self?.enableButton(enable)
        }
        viewModel?.endEditing = { [weak self] in
            self?.view.endEditing(true)
        }
    }

    private func showOfflineView(_ show: Bool) {
        offlineView.isHidden = !show
    }

    private func updateAvatar(_ image: UIImage?) {
        avatarImageView.image = image
    }

    private func updateTitle(_ text: String?) {
        self.title = text
    }

    private func updateNote(_ text: String?) {
        userNoteTextView.text = text
    }

    private func enableButton(_ enable: Bool) {
        addNoteButton.isEnabled = enable
    }

    private func showLoading(_ show: Bool) {
        if show {
            activityIndicatorView.startAnimating()
        } else {
            activityIndicatorView.stopAnimating()
        }
    }

    @objc private func hideKeyboard() {
        viewModel?.endEditing?()
    }

}

// MARK: - UITextViewDelegate

extension UserProfileView: UITextViewDelegate {

    func textViewDidBeginEditing(_ textView: UITextView) {
        viewModel?.textViewDidBeginEditing()
    }

}
