//
//  RootView.swift
//  movie-app-live
//
//  Created by Gergo Szabo on 2025. 05. 17..
//

import SwiftUI
import Combine

struct RootView: View {
    @State var selectedTab: TabType = TabType.genre
    @StateObject private var viewModel = RootViewModel()

    var body: some View {
        ZStack(alignment: .top) {
            MainTabView(selectedTab: $selectedTab)

            if !viewModel.isConnected {
                OfflineBannerView()
            }
        }
    }
}

