// DetailView.swift
//  movie-app-live
//
//  Created by Gergo Szabo on 2025. 05. 11..
//

import SwiftUI

struct DetailView: View {
    @StateObject private var viewModel = DetailViewModel()
    let mediaItem: MediaItem
    @Environment(\.dismiss) private var dismiss: DismissAction
    
    var body: some View {
        var mediaItemDetail: MediaItemDetail {
            viewModel.mediaItemDetail
        }
        
        var credits: [CastMember] {
            viewModel.credits
        }
        
        return ScrollView {
            VStack(alignment: .leading, spacing: LayoutConst.largePadding) {
                LoadImageView(url: mediaItemDetail.imageUrl)
                    .frame(height: 180)
                    .frame(maxWidth: .infinity)
                    .cornerRadius(30)
                
                HStack(spacing: 12.0) {
                    MovieLabel(type: .rating(mediaItemDetail.rating))
                    MovieLabel(type: .voteCount(mediaItemDetail.voteCount))
                    MovieLabel(type: .popularity(mediaItemDetail.popularity))
                    Spacer()
                    MovieLabel(type: .adult(mediaItemDetail.adult))
                }
                
                Text(viewModel.mediaItemDetail.genreList)
                    .font(Fonts.paragraph)
                MediaItemHeaderView(title: viewModel.mediaItemDetail.title,
                                    year: mediaItemDetail.year,
                                    runtime: "\(mediaItemDetail.runtime)",
                                    spokenLanguages: mediaItemDetail.spokenLanguages)
                
                HStack {
                    NavigationLink(destination: AddReviewView(mediaItemDetail: mediaItemDetail)) {
                        StyledButton(style: .outlined, action: .simple, title: "detail.rate.button")
                    }
                    
                    Spacer()
                    StyledButton(style: .filled, action: .link(mediaItemDetail.imdbURL), title: "detail.imdb.button")
                }
                
                VStack(alignment: .leading, spacing: 12.0) {
                    Text(LocalizedStringKey("detail.overview"))
                        .font(Fonts.overviewText)
                    
                    Text(mediaItemDetail.overview)
                        .font(Fonts.paragraph)
                        .lineLimit(nil)
                }
                
                // Itt van a módosítás a productionCompanies és credits ParticipantScrollView-jában
                ParticipantScrollView(title: "detail.publishers", participants: mediaItemDetail.productionCompanies, navigationType: .company)
                
                ParticipantScrollView(title: "detail.cast", participants: credits, navigationType: .castMember)
            }
            .padding(.horizontal, LayoutConst.maxPadding)
            .padding(.bottom, LayoutConst.largePadding)
            
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    viewModel.favoriteButtonTapped.send(())
                }) {
                    Image(viewModel.isFavorite ? .star : .star)
                        .resizable()
                        .frame(height: 30.0)
                        .frame(width: 30.0)
                }
            }
        }
        .showAlert(model: $viewModel.alertModel)
        .onAppear {
            viewModel.mediaItemIdSubject.send(mediaItem.id)
        }
    }
}
