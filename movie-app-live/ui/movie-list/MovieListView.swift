//
//  MovieListViewq.swift
//  movie-app-live
//
//  Created by Gergo Szabo on 2025. 04. 28..
//

import SwiftUI
import InjectPropertyWrapper

struct MovieListView: View {
    @StateObject private var viewModel = MovieListViewModel()
    let genre: Genre
    
    let columns = [
        GridItem(.adaptive(minimum: 150), spacing: 16)
    ]
    
    var body: some View {
        ScrollView {
            //lazy: csak akkor példányositja, ha ténylegesen szükséges
                //csak azokat, melyeket ténylegesen látunk
                //scrolloláskor jelen esetben - mindig ujrahasznositja a cellát
            LazyVGrid(columns: columns, spacing: LayoutConst.largePadding){
                ForEach(viewModel.movies){ movie in
                    MovieCell(movie: movie)
                }
            }
                      .padding(.horizontal, LayoutConst.normalPadding)
                      .padding(.top, LayoutConst.normalPadding)
        }
        .navigationTitle(genre.name)
        .onAppear{
//            viewModel.loadMovies(by: genre.id)
            viewModel.genreIdSubject.send(genre.id)
        }
    }
}

#Preview {
    MovieListView(genre: Genre(id: 28, name: "Action"))
        .environmentObject(FavoritesManager.manager)
}
