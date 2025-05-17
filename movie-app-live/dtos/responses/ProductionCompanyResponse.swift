//
//  ProductionCompanyResponse.swift
//  movie-app-live
//
//  Created by Gergo Szabo on 2025. 05. 11..
//

import Foundation

struct ProductionCompanyResponse: Decodable {
    let id: Int
    let name: String
    let logoPath: String?

    enum CodingKeys: String, CodingKey {
        case id, name
        case logoPath = "logo_path"
    }
}
