//
//  CastMemberCreditsView.swift
//  movie-app-live
//
//  Created by Gergo Szabo on 2025. 06. 28..
//


// CastMemberCreditsView.swift
// movie-app-live
//
// Created by Gergo Szabo on 2025. 06. 28..
//

import SwiftUI
import Lottie

struct CastMemberCreditsView: View {
    let personId: Int
    let personName: String // Kényelmi okokból, hogy legyen title a navigation bar-nak
    
    @StateObject private var viewModel = CastMemberCreditsViewModel()
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: LayoutConst.largePadding) {
                if viewModel.isLoading {
                    // Lottie animáció, amíg tölt
                    LottieView(animation: .named("movies"))
                        .playing(loopMode: .loop)
                        .frame(width: 100, height: 100)
                        .background(Color.clear)
                        .transition(.opacity)
                        .frame(maxWidth: .infinity, alignment: .center) // Középre igazítás
                } else if viewModel.combinedCredits.isEmpty {
                    Text(LocalizedStringKey("cast_member_credits.no_roles_found")) // Add hozzá Localizable.strings-hez
                        .font(Fonts.paragraph)
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding()
                } else {
                    ScrollView(.horizontal){
                        LazyHStack(spacing: LayoutConst.smallPadding) {
                            ForEach(viewModel.combinedCredits) { mediaItem in
                                NavigationLink(destination: DetailView(mediaItem: mediaItem)) {
                                    MediaItemCell(movie: mediaItem)
                                        .frame(width: 180)
                                    //CastMemberCreditRow(mediaItem: mediaItem) // Saját komponens a sorhoz
                                }
                                .buttonStyle(PlainButtonStyle()) // Hogy ne legyen kék a link
                            }
                        }
                    }
                }
            }
            .padding(.horizontal, LayoutConst.maxPadding)
            .padding(.bottom, LayoutConst.largePadding)
        }
        .navigationTitle(personName) // Navigation bar cím
        .navigationBarTitleDisplayMode(.inline)
        .showAlert(model: $viewModel.alertModel)
        .onAppear {
            viewModel.fetchCredits(forPersonId: personId)
        }
    }
}

// Komponens egyetlen szereplés megjelenítéséhez (mint a CombinedCreditRow korábban)
struct CastMemberCreditRow: View {
    let mediaItem: MediaItem

    var body: some View {
        HStack {
            LoadImageView(url: mediaItem.imageUrl)
                .frame(width: 50, height: 75)
                .cornerRadius(5)
            
            VStack(alignment: .leading) {
                Text(mediaItem.title)
                    .font(Fonts.subheading)
                    .lineLimit(1)
                
                Text("\(mediaItem.year)\(mediaItem.character != nil ? " - mint \(mediaItem.character!)" : "")")
                    .font(Fonts.paragraph)
                    .foregroundColor(.gray)
            }
            Spacer()
        }
    }
}
