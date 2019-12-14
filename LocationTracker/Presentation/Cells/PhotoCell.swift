//
//  PhotoCell.swift
//  LocationTracker
//
//  Created by Elizaveta Konysheva on 14.12.19.
//  Copyright © 2019 Elizaveta Konysheva. All rights reserved.
//

import UIKit

final class PhotoCell: UITableViewCell {
    private let photoImageView = UIImageView()
    private let loadingIndicator = UIActivityIndicatorView(style: .gray)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none
        photoImageView.add(into: contentView)
        loadingIndicator.add(into: photoImageView)
        loadingIndicator.hidesWhenStopped = true
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        photoImageView.image = nil
    }

    func setup(with viewModel: PhotoCellViewModel) {
        viewModel.viewStateUpdated = {
            self.updateViewState($0)
        }
        viewModel.loadImage()
    }

    private func updateViewState(_ state: PhotoCellViewState) {
        switch state {
        case .loading:
            loadingIndicator.startAnimating()
        case .loaded(let image):
            loadingIndicator.stopAnimating()
            photoImageView.image = image
            photoImageView.contentMode = .scaleAspectFit
        case .loadingFailed:
            loadingIndicator.stopAnimating()
            photoImageView.contentMode = .center
            photoImageView.image = UIImage(named: "icon-warning")
        }
    }
}
