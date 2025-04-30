//
//  GenreSectionCell.swift
//  movie-app-live
//
//  Created by Gergo Szabo on 2025. 04. 28..
//

import SwiftUI

struct GenreSectionCell: View {
    var genre: Genre
    
    var body: some View {
        HStack{
            Text(genre.name)
                .font(Fonts.title)
                .foregroundStyle(.primary)
                .accessibilityLabel(genre.name)
            Spacer()
            Image(.rightArrow)
        }
    }
}
