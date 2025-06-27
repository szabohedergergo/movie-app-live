//
//  MovieLabel.swift
//  movie-app-live
//
//  Created by Gergo Szabo on 2025. 04. 28..
//

import SwiftUI

enum MediaItemLabelType{
    case rating(_ value: Double)
    case voteCount(_ vote: Int)
    case popularity(_ vote: Double)
    case adult(_ adult: Bool)
}

struct MediaItemLabel: View {
    let type: MediaItemLabelType
    
    var body: some View {
        var imageRes: ImageResource
        var text: String
        
        switch type{
        case .rating(let value):
            text = String(format: "%.1f", value)
            imageRes = .star
        case .voteCount(let vote):
            text = "\(vote)"
            imageRes = .heart
        case .popularity(let vote):
            text = "\(vote)"
            imageRes = .person
        case .adult(let adult):
            text = adult ? "available" : "unavailable"
            imageRes = .cc
        }
        
        return HStack(spacing: 6){
            Image(imageRes)
            Text(LocalizedStringKey(text))
                .font(Fonts.labelBold)
        }
        .padding(6.0)
        .background(Color.main.opacity(0.5))
        .cornerRadius(12)
    }
}
