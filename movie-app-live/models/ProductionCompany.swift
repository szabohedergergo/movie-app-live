//
//  ProductionCompany.swift
//  movie-app-live
//
//  Created by Gergo Szabo on 2025. 05. 11..
//

import Foundation

struct ProductionCompany: Decodable, Identifiable {
    let id: Int
    let name: String
    let logoPath: String?
    
    var logoURL: URL? {
        logoPath.flatMap{ URL(string: "https://image.tmdb.org/t/p/w185\($0)") }
    }
    
    init(dto: ProductionCompanyResponse) {
        self.id = dto.id
        self.name = dto.name
        self.logoPath = dto.logoPath
    }
}
