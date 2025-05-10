//
//  MovieDetailView.swift
//  movie-app-live
//
//  Created by Gergo Szabo on 2025. 05. 10..
//

import SwiftUI

struct MovieDetailView: View {
    let movie: MediaItem

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                HeaderImageSection(movie: movie)
                InfoBadgesSection(movie: movie)
                TitleAndGenresSection(movie: movie)
                MetaDataSection(movie: movie)
                ActionButtonsSection(movie: movie)
                SynopsisSection(movie: movie)
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct HeaderImageSection: View {
    let movie: MediaItem

    var body: some View {
        ZStack(alignment: .topTrailing) {
            AsyncImage(url: movie.imageUrl) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 180)
                    .frame(maxHeight: 180)
                    .frame(maxWidth: .infinity)
                    .cornerRadius(12)
            } placeholder: {
                Rectangle().fill(Color.gray.opacity(0.3))
                    .frame(height: 220)
                    .cornerRadius(20)
            }

            Button(action: {
            }) {
                Image(systemName: "heart")
                    .padding()
                    .background(Color.red)
                    .clipShape(Circle())
                    .foregroundColor(.white)
            }
            .padding(.top, 12)
            .padding(.trailing, 12)
        }
    }
}

struct InfoBadgesSection: View {
    let movie: MediaItem

    var body: some View {
        HStack(spacing: 12) {
            Label {
                Text("\(movie.rating, specifier: "%.1f")")
            } icon: {
                Image(.star)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20) 
            }
            .badgeStyle()

            Label {
                Text("\(movie.voteCount)")
            } icon: {
                Image(.heart) // A saját heart kép
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
            }
            .badgeStyle()


            Label("N/A", systemImage: "bitcoinsign.circle") // Placeholder
                .badgeStyle()

            Label("Available", systemImage: "captions.bubble") // Placeholder
                .badgeStyle()
        }
    }
}

extension Label {
    func badgeStyle() -> some View {
        self.padding(8)
            .background(Color.gray.opacity(0.2))
            .clipShape(Capsule())
    }
}

struct TitleAndGenresSection: View {
    let movie: MediaItem

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            if movie.genres.isEmpty {
                Text("No genres available")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            } else {
                Text(movie.genres.map { $0.name }.joined(separator: ", "))
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }

            Text(movie.title)
                .font(.title)
                .fontWeight(.bold)
        }
    }
}

struct MetaDataSection: View {
    let movie: MediaItem

    var body: some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading) {
                Text("Release Year")
                    .font(.caption)
                Text(movie.year)
            }
            VStack(alignment: .leading) {
                Text("Runtime")
                    .font(.caption)
                Text(movie.displayDuration)
            }
            VStack(alignment: .leading) {
                Text("Language")
                    .font(.caption)
                Text(movie.displayLanguage)
            }
        }
    }
}


struct ActionButtonsSection: View {
    let movie: MediaItem

    var body: some View {
        HStack {
            Button("Rate this movie") {
                // Action
            }
            .padding()
            .overlay(RoundedRectangle(cornerRadius: 15).stroke(Color.white, lineWidth: 2))

            if let homepage = movie.homepage, !homepage.isEmpty {
                Button("Visit Website") {
                    // Open the movie's homepage URL
                    if let url = URL(string: homepage) {
                        UIApplication.shared.open(url)
                    }
                }
                .padding()
                .background(Color.white)
                .foregroundColor(.black)
                .clipShape(RoundedRectangle(cornerRadius: 15))
            } else {
                Button("Visit on IMDB") {
                    // Placeholder for IMDB button
                }
                .padding()
                .background(Color.white)
                .foregroundColor(.black)
                .clipShape(RoundedRectangle(cornerRadius: 15))
            }
        }
    }
}

struct SynopsisSection: View {
    let movie: MediaItem

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Synopsis")
                .font(.headline)

            Text(movie.overview ?? "No overview available") // Display overview or default text if it's nil
                .font(.body)
        }
    }
}
