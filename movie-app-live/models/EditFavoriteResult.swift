//
//  EditFavoriteResult.swift
//  movie-app-live
//
//  Created by Gergo Szabo on 2025. 06. 24..
//


struct ModifyMediaResultResponse : Decodable {
    let success : Bool
    let statusCode : Int
    let statusMessage : String

    enum CodingKeys: String, CodingKey {
        case success
        case statusCode = "status_code"
        case statusMessage = "status_message"
    }
}
