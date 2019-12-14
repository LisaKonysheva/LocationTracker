//
//  PhotosList.swift
//  LocationTracker
//
//  Created by Elizaveta Konysheva on 14.12.19.
//  Copyright © 2019 Elizaveta Konysheva. All rights reserved.
//

import Foundation

struct PhotosList: Decodable {
    let photos: [Photo]

    private enum CodingKeys: String, CodingKey {
        case photos = "photos"
        case photo = "photo"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let photosContaner = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .photos)
        photos = try photosContaner.decode([Photo].self, forKey: .photo)
    }
}
