//
//  CastMemberResponse.swift
//  movie-app-live
//
//  Created by Gergo Szabo on 2025. 06. 17..
//

struct CastMemberResponse: Codable, Identifiable {
    let id: Int
    let name: String
    let profilePath: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case profilePath = "profile_path"
    }
}
