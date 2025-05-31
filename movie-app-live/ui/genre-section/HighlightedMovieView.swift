//
//  HighlightedMovieView.swift
//  movie-app-live
//
//  Created by Gergo Szabo on 2025. 05. 31..
//

import SwiftUI

struct HighlightedMovieView: View {
    let movie: MediaItem

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            LoadImageView(url: movie.imageUrl) //vagy backdrop url
                .aspectRatio(contentMode: .fill)
                .frame(height: 280)
                .clipped() // Levágja a kép kilógó részeit
                .overlay( // átmenet alulra, jobban olvasható
                    LinearGradient(
                        gradient: Gradient(colors: [.clear, .black.opacity(0.2), .black.opacity(0.8)]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )

            VStack(alignment: .leading) {
                Text(movie.title)
                    .font(.title.bold())
                    .foregroundColor(.white)
                    .padding(.bottom, 4)
            }
            .padding()
        }
        .cornerRadius(15)
        .padding(.horizontal)
        .padding(.bottom)
    }
}
