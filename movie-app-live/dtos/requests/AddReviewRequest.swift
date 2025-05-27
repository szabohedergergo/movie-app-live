//
//  AddReviewRequest.swift
//  movie-app-live
//
//  Created by Gergo Szabo on 2025. 05. 24..
//

struct AddReviewBodyRequest: Encodable{
    let mediaId: Int
    let rating: Double
    
    enum CodingKeys: String, CodingKey {
        case mediaId = "movie_id"
        case rating = "value"
    }

}

struct AddReviewRequest: Encodable {
    let accessToken: String = Config.bearerToken
    let mediaId: Int
    let rating: Double
    
    func asRequestParams() -> [String: Any] {
        return [
            "movie_id": mediaId,
            "value": rating
        ]
    }
}
