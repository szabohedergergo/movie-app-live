//
//  ContentView.swift
//  movie-app-live
//
//  Created by Gergo Szabo on 2025. 04. 08..
//

import SwiftUI

class GenreSectionViewModel: ObservableObject {
    @Published var genres: [Genre] = []

    func loadGenres() {
        self.genres = [
            Genre(id: 1, name: "Adventure"),
            Genre(id: 2, name: "Sci-fi"),
            Genre(id: 3, name: "Fantasy"),
            Genre(id: 4, name: "Comedy")
        ]
    }
}

struct GenreSectionView: View {

    // akkor használjuk ha belső változás kell figyelni
    // és nem int, string stb hanem state?
    @StateObject private var viewModel = GenreSectionViewModel()

    var body: some View {
        ZStack (alignment: .topTrailing){
            NavigationView {
                List(viewModel.genres) { genre in
                    ZStack {
                        NavigationLink(destination: Color.gray) {
                            EmptyView()
                        }
                        .opacity(0.2)
                        .background(Color.blue)
                        
                        HStack {
                            Text(genre.name)
                                .font(Fonts.title)
                                .foregroundStyle(Color.primary)
                            Spacer()
                            Image(.rightArrow)
                        }.background(Color.red)
                    }
                    .listRowBackground(Color.green)
                    .listRowSeparator(.hidden)
                }
                .listStyle(.plain)
                .navigationTitle("genreSection.title") // multi langual
                // lokalizáció, többnyelvűség
                //.background(Color.cyan)
                .background(Color.clear)
            }
            .background(Color.green)
        
            Image(.redPiece)
        }
        .ignoresSafeArea(edges: .top)
        .onAppear(){
            viewModel.loadGenres()
        }

        //.onTapGesture {
        //    viewModel.loadGenres()
        //}
    }
}

#Preview {
    GenreSectionView()
}
