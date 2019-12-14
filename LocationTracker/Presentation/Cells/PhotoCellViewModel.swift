//
//  PhotoCellViewModel.swift
//  LocationTracker
//
//  Created by Elizaveta Konysheva on 14.12.19.
//  Copyright © 2019 Elizaveta Konysheva. All rights reserved.
//

import Foundation
import UIKit

protocol PhotoCellViewModel: class {
    var viewStateUpdated: ((PhotoCellViewState) -> Void)? { get set }
    var location: VisitedLocation { get }
    func loadImage()
}

enum PhotoCellViewState {
    case loading
    case loaded(UIImage)
    case loadingFailed
}

final class PhotoCellViewModelImpl: PhotoCellViewModel {
    var viewStateUpdated: ((PhotoCellViewState) -> Void)?

    let location: VisitedLocation
    private let networkService: NetworkService
    private let fetchPhotoService: FetchPhotoService
    private let errorCallback: (Error) -> Void
    private var image: UIImage?

    init(networkService: NetworkService,
         fetchPhotoService: FetchPhotoService,
         location: VisitedLocation,
         errorCallback: @escaping (Error) -> Void) {
        self.networkService = networkService
        self.fetchPhotoService = fetchPhotoService
        self.location = location
        self.errorCallback = errorCallback
    }

    func loadImage() {
        guard let image = image else {
            viewStateUpdated?(.loading)
            fetchPhotoService.fetchPhoto(for: location.location) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let photo):
                    self.networkService.perform(request: URLRequest(url: photo.url)) { result in
                        if let data = try? result.get(), let image = UIImage(data: data) {
                            self.image = image
                            self.viewStateUpdated?(.loaded(image))
                        } else {
                            self.viewStateUpdated?(.loadingFailed)
                        }
                    }
                case .failure(let error):
                    self.errorCallback(error)
                    self.viewStateUpdated?(.loadingFailed)
                    print(error)
                }
            }
            return
        }
        self.viewStateUpdated?(.loaded(image))
    }
}
