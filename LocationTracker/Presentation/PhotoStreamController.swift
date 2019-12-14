//
//  PhotoStreamController.swift
//  LocationTracker
//
//  Created by Elizaveta Konysheva on 14.12.19.
//  Copyright © 2019 Elizaveta Konysheva. All rights reserved.
//

import UIKit

final class PhotoStreamController: UIViewController {

    var viewModel: PhotoStreamViewModel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupBindings()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.isEnabled = true

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(applicationDidBecomeActive),
            name: UIApplication.didBecomeActiveNotification,
            object: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(
            self,
            name: UIApplication.didBecomeActiveNotification,
            object: nil)
    }

    @objc func applicationDidBecomeActive() {
        viewModel.applicationDidBecomeActive()
    }

    private func setupUI() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: nil,
            style: .plain,
            target: self,
            action: #selector(actionButtonTapped))
        tableView.register(cellWithClass: PhotoCell.self)
    }

    private func setupBindings() {
        viewModel.callbacks = PhotoStream.Callbacks(
            viewStateChanged: { [weak self] in
                self?.updateViewState($0) },
            dataUpdated: { [weak self] in
                self?.tableView.reloadData() },
            permissionsAlert: { [weak self] in
                self?.displayPermissionsAlert() },
            error: { [weak self] in
                self?.displayError($0)
        })
    }

    private func updateViewState(_ state: PhotoStream.ViewState) {
        navigationItem.rightBarButtonItem?.title = state.buttonTitle
        statusLabel.text = state.statusTitle
    }

    private func displayPermissionsAlert() {
        let permissionAlert = UIAlertController(
            title: "Access denied",
            message: "We need location permission to proceed with this action. To change the permissions settings, please use the settings button below",
            preferredStyle: .alert)

        let settingsAction = UIAlertAction(
            title: "Settings",
            style: .default,
            handler: { _ in
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url, completionHandler: nil)
                }
        })
        let cancelAction = UIAlertAction(
            title: "Cancel",
            style: .cancel,
            handler :nil)

        permissionAlert.addAction(settingsAction)
        permissionAlert.addAction(cancelAction)
        present(permissionAlert, animated: true, completion: nil)
    }

    private func displayError(_ error: Error) {
        guard let displayText = (error as? ErrorPresentable)?.displayText else {
            return
        }
        errorLabel.text = displayText
        errorLabel.isHidden = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.errorLabel.isHidden = true
        }
    }

    @objc func actionButtonTapped() {
        viewModel.updateTrackingStatus()
    }
}

extension PhotoStreamController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.photos.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: PhotoCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.setup(with: viewModel.photos[indexPath.row])
        return cell
    }
}
