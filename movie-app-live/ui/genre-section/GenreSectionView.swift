//
//  ContentView.swift
//  movie-app-live
//
//  Created by Gergo Szabo on 2025. 04. 08..
//

import SwiftUI
import InjectPropertyWrapper

protocol GenreSectionViewModelProtocol: ObservableObject{
    
}

class GenreSectionViewModel: GenreSectionViewModelProtocol {
    @Published var genres: [Genre] = []
    
    //private var movieService: MoviesServiceProtocol = MovieService()
    //ehelyett injectpropertywrapper
    
    @Inject
    private var movieService: MoviesServiceProtocol
    
    func fetchGenres() async {
//        self.genres = [
//            Genre(id: 1, name: "Adventure"),
//            Genre(id: 2, name: "Sci-fi"),
//            Genre(id: 3, name: "Fantasy"),
//            Genre(id: 4, name: "Comedy")
//        ]
        
        do {
            let request = FetchGenreRequest()
            let genres = Environments.name == .tvlist ? try await movieService.fetchTVGenres(req: request) : try await movieService.fetchGenres(req: request)
            self.genres = genres
        } catch {
            print("Error fetching genres: \(error)")
        }
    }
}

struct GenreSectionView: View {

    // akkor használjuk ha belső változás kell figyelni
    // és nem int, string stb hanem state?
    @StateObject private var viewModel = GenreSectionViewModel()
    

    var body: some View {
        ZStack (alignment: .topTrailing){
            NavigationView {
                List(viewModel.genres) { genre in
                    ZStack {
                        NavigationLink(destination: MovieListView(genre: genre)) {
                            EmptyView()
                        }
                        .opacity(0.2)
                        //.background(Color.blue)
                        
                        HStack {
                            Text(genre.name)
                                .font(Fonts.title)
                                .foregroundStyle(Color.primary)
                            Spacer()
                            Image(.rightArrow)
                        }//.background(Color.red)
                    }
                    //.listRowBackground(Color.green)
                    .listRowSeparator(.hidden)
                }
                .listStyle(.plain)
                //.navigationTitle("genreSection.title") // multi langual
                // lokalizáció, többnyelvűség
                //.background(Color.cyan)
                //.navigationTitle(Environments.name == .dev ? "DEV" : "PROD")
                .navigationTitle({
                    switch Environments.name{
                        case .dev: return "DEV"
                        case .prod: return "PROD"
                        case .tvlist: return "TVLIST"
                    }
                }())
                .background(Color.clear)
            }
        
            Image(.redPiece)
        }
        .ignoresSafeArea(edges: .top)
        .onAppear(){
            //viewModel.fetchGenres()
            Task{ //maga az async hivás a háttérben fusson le
                await viewModel.fetchGenres()
            }
        }

        //.onTapGesture {
        //    viewModel.loadGenres()
        //}
    }
}

#Preview {
    GenreSectionView()
}
