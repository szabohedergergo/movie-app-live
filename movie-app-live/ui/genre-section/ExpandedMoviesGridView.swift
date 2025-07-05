//
//  ExpandedMoviesGridView.swift
//  movie-app-live
//
//  Created by Gergo Szabo on 2025. 05. 31..
//


import SwiftUI

struct ExpandedMoviesGridView: View {
    let genreID: Int
    @StateObject private var movieListViewModel = MediaItemListViewModel()

    let columns: [GridItem] = [
        // Ez biztosítja, hogy minden oszlopnak legyen egy minimum szélessége
        GridItem(.flexible(minimum: 100), spacing: 12), // Minimum 100 pont szélesség
        GridItem(.flexible(minimum: 100), spacing: 12),
        GridItem(.flexible(minimum: 100), spacing: 12)
    ]
    let rowSpacing: CGFloat = 16

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, alignment: .center, spacing: rowSpacing) {
                ForEach(movieListViewModel.movies.indices, id: \.self) {index in
                    let movie = movieListViewModel.movies[index]
                    
                    MediaItemCell(movie: movie)
//                        .onAppear{
//                            if index == movieListViewModel.movies.count - 1
//                                && !movieListViewModel.isLoading{
//                                print("REACHEDBOTTOM: movies[\(index)] out of \(movieListViewModel.movies.count)")
//                                movieListViewModel.reachedBottomSubject.send(())
//                            }
//                        }
                }
            
                
                Text("Yo").onAppear{
                    print("ggiga appear")
                }

                
            }
            .onAppear {
                if movieListViewModel.movies.isEmpty {
                    print("SEND=========")
                    movieListViewModel.genreIdSubject.send(genreID) //
                    //movieListViewModel.refreshMovies(genreId: genreID)
                }
                else{
                    print("yo")
                }
            }
            .padding(.horizontal)
        }
        
        // GenreSectionView: görgetés
        .onAppear {
            if movieListViewModel.movies.isEmpty {
                print("SEND=========")
                //movieListViewModel.genreIdSubject.send(genreID) //
                //movieListViewModel.refreshMovies(genreId: genreID)
            }
            else{
                print("yo")
            }
        }
    }
}
