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
            Text("Favorites Screen")
                .navigationTitle("Favorites")
        }
    }
}

#Preview {
    FavoritesView()
}
