//
//  GenreSectionView.swift
//  movie-app-live
//
//  Created by Zsolt Pete on 2025. 04. 08..
//

import SwiftUI
import InjectPropertyWrapper

struct GenreSectionView: View {
    @StateObject private var viewModel = GenreSectionViewModel()
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            Image(.redPiece)
                .resizable()
                .scaledToFit()
                .padding(.leading, 150)
                .zIndex(0)
            
            NavigationView {
                List(viewModel.genres) { genre in
                    ZStack {
                        NavigationLink(destination: MovieListView(genre: genre)) {
                            EmptyView()
                        }
                        .opacity(0)
                        .onTapGesture {
                            SelectedGenresManager.selectedGenres.toggleGenre(id: genre.id)
                        }
                        
                        GenreSectionCell(genre: genre)
                    }
                    .background(Color.clear)
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                }
                .listStyle(.plain)
                .navigationTitle(Environments.name == .tvlist ? "TV" : "genreSection.title")
                .accessibilityLabel("testCollectionView")
                .background(Color.clear)
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
            }
            .background(Color.clear)
        }
        .ignoresSafeArea()
        .onAppear {
            //            Task {
            //                await viewModel.fetchGenres()
            //            }
            //nem kell a future után már
        }
        .showAlert(model: $viewModel.alertModel)
        //.modifier(AlertModifier(model: $viewModel.alertModel))
        
//        .alert(item: $viewModel.alertModel) { model in
//            return Alert(
//                title: Text(LocalizedStringKey(model.title)),
//                message: Text(LocalizedStringKey(model.message)),
//                dismissButton: .default(Text(LocalizedStringKey(model.dismissButtonTitle))) {
//                    viewModel.alertModel = nil
//                }
//            )
//        }
    }
}

#Preview {
    GenreSectionView()
}
