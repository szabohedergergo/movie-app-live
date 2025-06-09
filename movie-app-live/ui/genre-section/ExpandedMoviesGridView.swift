//
//  ExpandedMoviesGridView.swift
//  movie-app-live
//
//  Created by Gergo Szabo on 2025. 05. 31..
//


import SwiftUI

struct ExpandedMoviesGridView: View {
    let genreID: Int
    @StateObject private var movieListViewModel = MovieListViewModel()

    let columns: [GridItem] = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]
    let rowSpacing: CGFloat = 16

    var body: some View {
        LazyVGrid(columns: columns, alignment: .center, spacing: rowSpacing) {
//            ForEach(movieListViewModel.movies) { movie in
//                MovieCell(movie: movie)
//                    //width
//            }
            
            ForEach(movieListViewModel.movies.indices, id: \.self) {index in
                let movie = movieListViewModel.movies[index]
                
                MovieCell(movie: movie)
                    .onAppear{
                        if index == movieListViewModel.movies.count - 1 {
                            movieListViewModel.reachedBottomSubject.send()
                        }
                    }
            }
        }
        // GenreSectionView: görgetés
        .onAppear {
            movieListViewModel.genreIdSubject.send(genreID) //
        }
    }
}
