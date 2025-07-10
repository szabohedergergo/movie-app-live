// DetailView.swift
//  movie-app-live
//
//  Created by Gergo Szabo on 2025. 05. 11..
//

import SwiftUI
import Lottie

struct DetailView: View {
    @StateObject private var viewModel = DetailViewModel()
    let mediaItem: MediaItem
    @Environment(\.dismiss) private var dismiss: DismissAction
    
    var mediaItemDetail: MediaItemDetail {
        viewModel.mediaItemDetail
    }
    
    var credits: [CastMember] {
        viewModel.credits
    }
    
    var body: some View {
        
        return ZStack(alignment: .topTrailing){
            RedPieceBackgroundView()
            
            ScrollView {
                VStack(alignment: .leading, spacing: LayoutConst.largePadding) {
                    LoadImageView(url: mediaItemDetail.imageUrl)
                        .frame(height: 180)
                        .frame(maxWidth: .infinity)
                        .cornerRadius(30)
                    
                    HStack(spacing: 12.0) {
                        MediaItemLabel(type: .rating(mediaItemDetail.rating))
                        MediaItemLabel(type: .voteCount(mediaItemDetail.voteCount))
                        MediaItemLabel(type: .popularity(mediaItemDetail.popularity))
                        Spacer()
                        MediaItemLabel(type: .adult(mediaItemDetail.adult))
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
                        if let imdbURL = mediaItemDetail.imdbURL {
                            StyledButton(style: .filled, action: .link(imdbURL), title: "detail.imdb.button".localized())
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 12.0) {
                        Text(LocalizedStringKey("detail.overview"))
                            .font(Fonts.overviewText)
                        
                        Text(mediaItemDetail.overview)
                            .font(Fonts.paragraph)
                            .lineLimit(nil)
                    }
                    
                    ParticipantScrollView(title: "detail.publishers", participants: mediaItemDetail.productionCompanies, navigationType: .company)
                    
                    ParticipantScrollView(title: "detail.cast", participants: credits, navigationType: .castMember)
                    
                    ReviewScrollView(reviews: viewModel.reviews)
                    
                    if !viewModel.similarMovies.isEmpty || viewModel.isLoadingSimilarMovies {
                        VStack(alignment: .leading, spacing: LayoutConst.largePadding){
                            Text(Environments.name == .tvlist ? LocalizedStringKey("detail.similar_series") : LocalizedStringKey("detail.similar_movies"))
                                .font(Fonts.overviewText)
                            
                            ScrollView(.horizontal, showsIndicators: false){
                                LazyHStack(spacing: LayoutConst.maxPadding){
                                    ForEach(viewModel.similarMovies) { movie in
                                        MediaItemCell(movie: movie)
                                            .frame(width: 180)
                                            .onAppear{
                                                if let lastMovie = viewModel.similarMovies.last, movie.id == lastMovie.id {
                                                    viewModel.fetchMoreSimilarMovies.send(())
                                                }
                                            }
                                    }
                                    
                                    if viewModel.isLoadingSimilarMovies {
                                        LottieView(animation: .named("loading"))
                                            .playing(loopMode: .loop)
                                            .frame(width: 100, height: 100)
                                            .background(Color.clear)
                                            .transition(.opacity)
                                    }
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal, LayoutConst.maxPadding)
                .padding(.bottom, LayoutConst.largePadding)
                
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        viewModel.favoriteButtonTapped.send(())
                    }) {
                        Image(viewModel.isFavorite ? .favorite : .nonfavorite)
                            .resizable()
                            .frame(height: 30.0)
                            .frame(width: 30.0)
                    }
                }
            }
            .showAlert(model: $viewModel.alertModel)
            .onAppear {
                viewModel.mediaItemSubject.send(mediaItem)
            }
        }
    }
}
