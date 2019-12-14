//
//  Photo.swift
//  LocationTracker
//
//  Created by Elizaveta Konysheva on 14.12.19.
//  Copyright © 2019 Elizaveta Konysheva. All rights reserved.
//

import Foundation

struct Photo: Decodable {
    let url: URL
    let id: String

    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case url = "url_m"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        url = try container.decode(URL.self, forKey: .url)
    }

    init(id: String, url: URL) {
        self.id = id
        self.url = url
    }
}
