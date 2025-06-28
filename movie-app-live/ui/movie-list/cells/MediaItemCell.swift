//
//  MovieCell.swift
//  movie-app-live
//
//  Created by Gergo Szabo on 2025. 04. 29..
//

import SwiftUI

struct MediaItemCell: View {
    let movie: MediaItem
    @EnvironmentObject var favManager: FavoritesManager
    
    var body: some View {
        NavigationLink(destination: DetailView(mediaItem: movie)){
            if(movie.id >= 0){
                VStack(alignment: .leading, spacing: LayoutConst.smallPadding){
                    ZStack(alignment: .topLeading){
                        HStack(alignment: .center){
                            LoadImageView(url: movie.imageUrl)
                                .frame(height: 100)
                                .frame(maxHeight: 180)
                                .frame(maxWidth: .infinity)
                                .cornerRadius(12)
                                .allowsHitTesting(false)
                        }
                        
                        HStack(alignment: .center){
                            Rectangle()
                                .opacity(0.000000001)
                                .allowsHitTesting(true)
                        }
                        
                        HStack (spacing: 12.0){
                            MediaItemLabel(type: .rating(movie.rating))
                            MediaItemLabel(type: .voteCount(movie.voteCount))
                        }
                        .padding(LayoutConst.smallPadding)
                        
                        VStack{
                            HStack{
                                Spacer()
                                Button(action: {
                                    withAnimation(.spring()){
                                        favManager.toggleFavorite(id: movie.id)
                                    }
                                }) {
                                    Image(.heart)
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                        .foregroundColor(
                                            .red//favManager.isFavorite(id: movie.id) ? .red : .white.opacity(0.6)
                                        )
                                        .padding(6.0)
                                        .background(Color.black.opacity(0.4))
                                        .cornerRadius(16.0)
                                }
                            }
                            Spacer()
                        }
                        .padding(8)
                    }
                    
                    Text(movie.title)
                        .font(Fonts.subheading)
                        .lineLimit(1)
                    
                    Text("\(movie.year)")
                        .font(Fonts.paragraph)
                    
                    Text("\(movie.duration)")
                        .font(Fonts.caption)
                    
                    Spacer()
                }
            }
            else{
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 200, height: 100)
                    .cornerRadius(12)
                    .shimmering()
            }
        }.buttonStyle(.plain)
    }
}
