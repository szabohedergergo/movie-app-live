//
//  FavoritesView.swift
//  movie-app-live
//
//  Created by Gergo Szabo on 2025. 04. 28..
//

import SwiftUI
import InjectPropertyWrapper

struct FavoritesView: View {
    @StateObject private var viewModel = FavoritesViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: LayoutConst.normalPadding) {
                    ForEach(viewModel.mediaItems.indices, id: \.self) { index in
                        let movie = viewModel.mediaItems[index]
                        NavigationLink(destination: DetailView(mediaItem: movie)) {
                            MediaItemCell(movie: movie)
                                .frame(height: 277)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .accessibilityLabel("MediaItem\(index)")
                    }
                }
                .padding(.horizontal, LayoutConst.normalPadding)
                .padding(.top, LayoutConst.normalPadding)
            }
            .navigationTitle("favoriteMovies.title")
            .accessibilityLabel(AccessibilityLabels.favoritesScrollView)
        }
        .showAlert(model: $viewModel.alertModel)
        .onAppear {
            viewModel.viewLoaded.send(())
        }
    }
}

#Preview {
    FavoritesView()
}
