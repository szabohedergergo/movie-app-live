//
//  DetailView.swift
//  movie-app-live
//
//  Created by Gergo Szabo on 2025. 05. 11..
//
//
import SwiftUI
//
struct DetailView: View {
    @StateObject private var viewModel = DetailViewModel()
    let mediaItem: MediaItem
    
    
    var body: some View {
        // A mediaItemDetail-t közvetlenül a viewModel-ből vesszük
        // var mediaItemDetail: MediaItemDetail {
        //     viewModel.mediaItemDetail
        // }
        // Hasonlóan a szereplőkhöz:
        // var cast: [CastMemberCredit] {
        //     viewModel.cast
        // }

        ScrollView {
            VStack(alignment: .leading, spacing: LayoutConst.largePadding) {
                AsyncImage(url: viewModel.mediaItemDetail.imageUrl) { phase in
                    switch phase {
                    case .empty:
                        ZStack {
                            Color.gray.opacity(0.3)
                            ProgressView()
                        }
                    case let .success(image):
                        image
                            .resizable()
                            .scaledToFill()
                    case .failure:
                        ZStack {
                            Color.red.opacity(0.3)
                            Image(systemName: "photo")
                                .foregroundColor(.white)
                        }
                    @unknown default:
                        EmptyView()
                    }
                }
                .frame(height: 220)
                .frame(maxWidth: .infinity)
                .clipped() // kép ne lógjon ki a cornerRadius miatt
                .cornerRadius(10)
                .padding(.bottom, LayoutConst.normalPadding)

                HStack(spacing: 12.0) {
                    MovieLabel(type: .rating(viewModel.mediaItemDetail.rating))
                    MovieLabel(type: .voteCount(viewModel.mediaItemDetail.voteCount))
                    MovieLabel(type: .popularity(viewModel.mediaItemDetail.popularity))
                    Spacer()
                    MovieLabel(type: .adult(viewModel.mediaItemDetail.adult))
                }
                
                Text(viewModel.mediaItemDetail.genreList)
                    .font(Fonts.paragraph)
                    .foregroundColor(.gray)
                
                Text(viewModel.mediaItemDetail.title)
                    .font(Fonts.detailsTitle)
                    .fontWeight(.bold)
                
                HStack(spacing: LayoutConst.normalPadding) {
                    DetailLabel(title: "detail.releaseDate", desc: viewModel.mediaItemDetail.year)
                    DetailLabel(title: "detail.runtime", desc: "\(viewModel.mediaItemDetail.runtime) min")
                    DetailLabel(title: "detail.language", desc: viewModel.mediaItemDetail.spokenLanguages)
                }
                
                HStack {
                    StyledButton(style: .outlined, title: "detail.rate.button", action: { /* Rate action */ })
                    Spacer()
                    StyledButton(style: .filled, title: "detail.imdb.button", action: { /* IMDb action */ })
                }
                
                VStack(alignment: .leading, spacing: LayoutConst.normalPadding) {
                    Text(LocalizedStringKey("detail.overview"))
                        .font(Fonts.overviewText)
                        .fontWeight(.semibold)
                    
                    Text(viewModel.mediaItemDetail.overview)
                        .font(Fonts.paragraph)
                        .lineLimit(nil) // Engedélyezi a több sort
                }
                
                if !viewModel.mediaItemDetail.productionCompany.isEmpty {
                    VStack(alignment: .leading, spacing: LayoutConst.normalPadding) {
                        Text("Gyártó cégek")
                            .font(Fonts.overviewText)
                            .fontWeight(.semibold)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: LayoutConst.normalPadding) {
//                                ForEach(viewModel.mediaItemDetail.productionCompany, id: \.id) { company in
//                                    ProductionCompanyView(company: company)
//                                }
                                ForEach(viewModel.mediaItemDetail.productionCompany) { company in
                                    ProductionCompanyView(company: company)
                                }
                            }
                        }
                    }
                }

                if !viewModel.cast.isEmpty {
                    VStack(alignment: .leading, spacing: LayoutConst.normalPadding) {
                        Text("Szereplők")
                            .font(Fonts.overviewText)
                            .fontWeight(.semibold)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: LayoutConst.normalPadding) {
                                ForEach(viewModel.cast) { member in
                                    CastMemberView(member: member)
                                }
                            }
                        }
                    }
                }

            }
            .padding(.horizontal, LayoutConst.maxPadding)
            .padding(.bottom, LayoutConst.largePadding) // Padding az aljára, hogy ne tapadjon
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    //kedvencek
                }) {
                    Image(systemName: "heart.circle")
                        .resizable()
                        .frame(width: 30.0, height: 30.0)
                }
            }
        }
        .navigationTitle(viewModel.mediaItemDetail.title)
        .navigationBarTitleDisplayMode(.inline)
        .showAlert(model: $viewModel.alertModel)
        .onAppear {
            viewModel.mediaItemSubject.send(mediaItem.id)
        }
    }
}

struct CastMemberView: View {
    let member: CastMember
    
    var body: some View {
        VStack {
            AsyncImage(url: member.castImageURL) { phase in
                switch phase {
                case .empty:
                    ZStack {
                        Circle().fill(Color.gray.opacity(0.1))
                        ProgressView()
                    }
                case let .success(image):
                    image.resizable()
                        .aspectRatio(contentMode: .fill)
                case .failure:
                    ZStack {
                        Circle().fill(Color.gray.opacity(0.3))
                        Image(systemName: "person.fill")
                            .foregroundColor(.white)
                    }
                @unknown default:
                    EmptyView()
                }
            }
            .frame(width: 80, height: 80)
            .clipShape(Circle())
            .overlay(Circle().stroke(Color.gray.opacity(0.5), lineWidth: 1)) // keret
            
            Text(member.name)
                .font(Fonts.caption)
                .frame(width: 80)
                .lineLimit(2)
                .multilineTextAlignment(.center)
        }
    }
}

struct ProductionCompanyView: View {
    let company: ProductionCompany
    
    var body: some View {
        VStack {
            AsyncImage(url: company.logoURL) { phase in
                switch phase {
                case .empty:
                    ZStack {
                        RoundedRectangle(cornerRadius: 8).fill(Color.gray.opacity(0.1))
                        ProgressView()
                    }
                case let .success(image):
                    image.resizable()
                        .aspectRatio(contentMode: .fit) //nincs torzulas
                case .failure:
                    ZStack {
                        RoundedRectangle(cornerRadius: 8).fill(Color.gray.opacity(0.2))
                        Image(systemName: "building.2")
                            .foregroundColor(.white)
                    }
                @unknown default:
                    EmptyView()
                }
            }
            .frame(width: 100, height: 60)
            .padding(LayoutConst.normalPadding / 2)
            .background(Color.white.opacity(0.8))
            .cornerRadius(8)


            Text(company.name)
                .font(Fonts.caption)
                .frame(width: 100)
                .lineLimit(2)
                .multilineTextAlignment(.center)
        }
        .padding(.vertical, LayoutConst.normalPadding / 2)
    }
}

//struct DetailView: View {
//    @StateObject private var viewModel = DetailViewModel()
//    let mediaItem: MediaItem
//    
//    var body: some View {
//        
//        var mediaItemDetail: MediaItemDetail {
//            viewModel.mediaItemDetail
//        }
//        
//        return ScrollView {
//            VStack(alignment: .leading, spacing: LayoutConst.largePadding) {
//                AsyncImage(url: mediaItemDetail.imageUrl) { phase in
//                    switch phase {
//                    case .empty:
//                        ZStack {
//                            Color.gray.opacity(0.3)
//                            ProgressView()
//                        }
//
//                    case let .success(image):
//                        image
//                            .resizable()
//                            .scaledToFill()
//
//                    case .failure(let error):
//                        ZStack {
//                            Color.red.opacity(0.3)
//                            Image(systemName: "photo")
//                                .foregroundColor(.white)
//                        }
//                    @unknown default:
//                        EmptyView()
//                    }
//                }
//                .frame(height: 180)
//                .frame(maxWidth: .infinity)
//                .cornerRadius(30)
//                
//                HStack(spacing: 12.0) {
//                    MovieLabel(type: .rating(mediaItemDetail.rating))
//                    MovieLabel(type: .voteCount(mediaItemDetail.voteCount))
//                    MovieLabel(type: .popularity(mediaItemDetail.popularity))
//                    Spacer()
//                    MovieLabel(type: .adult(mediaItemDetail.adult))
//                }
//                
//                Text(viewModel.mediaItemDetail.genreList)
//                    .font(Fonts.paragraph)
//                Text(viewModel.mediaItemDetail.title)
//                    .font(Fonts.detailsTitle)
//                
//                HStack(spacing: LayoutConst.normalPadding) {
//                    DetailLabel(title: "detail.releaseDate", desc: mediaItemDetail.year)
//                    DetailLabel(title: "detail.runtime", desc: "\(mediaItemDetail.runtime)")
//                    DetailLabel(title: "detail.language", desc: mediaItemDetail.spokenLanguages)
//                }
//                
//                HStack {
//                    StyledButton(style: .outlined, title: "detail.rate.button")
//                    Spacer()
//                    StyledButton(style: .filled, title: "detail.imdb.button")
//                }
//                
//                VStack(alignment: .leading, spacing: 12.0) {
//                    Text(LocalizedStringKey("detail.overview"))
//                        .font(Fonts.overviewText)
//                    
//                    Text(mediaItemDetail.overview)
//                        .font(Fonts.paragraph)
//                        .lineLimit(nil)
//                }
//
//            }
//            .padding(.horizontal, LayoutConst.maxPadding)
//        }
//        .toolbar {
//            ToolbarItem(placement: .topBarTrailing) {
//                Button(action: {
//                    
//                }) {
//                    Image(.favoriteCircled)
//                        .resizable()
//                        .frame(height: 30.0)
//                        .frame(width: 30.0)
//                }
//            }
//        }
//        .showAlert(model: $viewModel.alertModel)
//        .onAppear {
//            viewModel.mediaItemSubject.send(mediaItem.id)
//        }
//    }
//}
