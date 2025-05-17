//
//  MovieCell.swift
//  movie-app-live
//
//  Created by Gergo Szabo on 2025. 04. 29..
//

import SwiftUI

struct MovieCell: View {
    let movie: MediaItem
    @EnvironmentObject var favManager: FavoritesManager
    
    var body: some View {
        NavigationLink(destination: DetailView(mediaItem: movie)){
            VStack(alignment: .leading, spacing: LayoutConst.smallPadding){
                ZStack(alignment: .topLeading){
                    HStack(alignment: .center){
                        AsyncImage(url: movie.imageUrl) { phase in
                            switch phase {
                            case .empty:
                                ZStack {
                                    Color.gray.opacity(0.3)
                                    ProgressView()
                                }
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFill()
                                //.frame(width: 150.0)
                                //.cornerRadius(20)
                                
                            case .failure(let error):
                                ZStack{
                                    Color.red.opacity(0.3)
                                    Image(systemName: "photo")
                                        .foregroundColor(.white)
                                }
                            @unknown default:
                                EmptyView()
                            }
                        }
                        .frame(height: 100)
                        .frame(maxHeight: 180)
                        .frame(maxWidth: .infinity)
                        .cornerRadius(12)
                    }
                    
                    HStack (spacing: 12.0){
                        MovieLabel(type: .rating(movie.rating))
                        MovieLabel(type: .voteCount(movie.voteCount))
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
                                        favManager.isFavorite(id: movie.id) ? .red : .white.opacity(0.6)
                                    )
                                    .padding(6.0)
                                    .background(Color.black.opacity(0.4))
                                //.clipShape(Circle())
                                    .cornerRadius(16.0)
                            }
                        }
                        Spacer()
                    }
                    .padding(8)
                }
                
                Text(movie.title)
                    .font(Fonts.subheading)
                    .lineLimit(2)
                
                Text("\(movie.year)")
                    .font(Fonts.paragraph)
                
                Text("\(movie.duration)")
                    .font(Fonts.caption)
                
                Spacer()
            }
        }.buttonStyle(.plain)
    }
}
