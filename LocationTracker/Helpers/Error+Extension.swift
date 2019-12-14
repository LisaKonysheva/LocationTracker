//
//  Error+Extension.swift
//  LocationTracker
//
//  Created by Elizaveta Konysheva on 15.12.19.
//  Copyright © 2019 Elizaveta Konysheva. All rights reserved.
//

import Foundation

protocol ErrorPresentable {
    var displayText: String? { get }
}

extension NetworkError: ErrorPresentable {
    var displayText: String? {
        switch self {
        case .serverError, .noData:
            return "Oops, server error occured!"
        case .noConnection:
            return "No connection, please try again when internet appears!"
        }
    }
}

extension FetchPhotoError: ErrorPresentable {
    var displayText: String? {
        switch self {
        case .emptyList:
            return "Sorry, no photos found for this location!"
        case .parsingError:
            return nil
        }
    }
}
