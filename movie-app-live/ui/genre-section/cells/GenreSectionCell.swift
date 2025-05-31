//
//  GenreSectionCell.swift
//  movie-app-live
//
//  Created by Gergo Szabo on 2025. 04. 28..
//

//
//  GenreSectionCell.swift
//  movie-app-live
//
//  Created by Gergo Szabo on 2025. 04. 28..
//

import SwiftUI

struct GenreSectionCell: View {
    var genre: Genre
    var isExpanded: Bool
    var onToggle: () -> Void
    
    var body: some View {
        HStack{
            Text(genre.name)
                .font(Fonts.title)
                .foregroundStyle(.primary)
                .accessibilityLabel(genre.name)
            Spacer()
            Image(.rightArrow)
                .rotationEffect(.degrees(isExpanded ? 90 : 0)) //genresectionview anim
        }
        .padding(.vertical, 12)
        .contentShape(Rectangle()) //egész sor kattintható
        .onTapGesture {
            onToggle()
        }
    }
}
