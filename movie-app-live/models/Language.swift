//
//  Language.swift
//  movie-app-live
//
//  Created by Gergo Szabo on 2025. 05. 10..
//

struct Language: Decodable, Hashable {
    let englishName: String

    enum CodingKeys: String, CodingKey {
        case englishName = "english_name"
    }
}
