import SwiftUI
import InjectPropertyWrapper
import FirebaseCrashlytics // Fontos: Importáld a Crashlytics-et!

struct GenreSectionView: View {
    @StateObject private var viewModel = GenreSectionViewModelImpl()
    @StateObject private var movieListViewModel = MovieListViewModel()
    @State private var expandedGenreID: Int?

    var body: some View {
        let title = Environments.name == .tvlist ? "TV" : "genreSection.title".localized() //
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    Button("Teszteld a Crash-t!") {
                        // Ez a sor fogja szándékosan összeomlasztani az alkalmazást!
                        // CSAK TESZTELÉSRE HASZNÁLD, ÉS NE HAGYD BENNE ÉLES VERZIÓBAN!
                        Crashlytics.crashlytics().record(error: MovieError.noInternetError) // Opcionális: Hozzáadhatsz egyedi kulcsot a crash-hez
                        fatalError("Ez egy teszt crash, amit a gomb váltott ki!")
                    }
                    
                    // 1. Kiemelt film
                    if let movie = viewModel.highlightedMovie {
                        HighlightedMovieView(movie: movie)
                    } else {
                        // placeholder
                        Rectangle()
                            .fill(Color.gray.opacity(0.1))
                            .frame(height: 280)
                            .cornerRadius(15)
                            .padding(.horizontal)
                            .padding(.bottom)
                    }

                    // 2. Műfajok listája
                    ForEach(viewModel.genres) { genre in //
                        ZStack{
                            NavigationLink(destination: MediaItemView(genre: genre)) {
                                EmptyView()
                            }
                            .opacity(0)
                            
                            VStack(alignment: .leading, spacing: 0) {
                                GenreSectionCell(
                                    genre: genre, //
                                    isExpanded: self.expandedGenreID == genre.id,
                                    onToggle: {
                                        withAnimation(.easeInOut(duration: 0.3)) {
                                            if self.expandedGenreID == genre.id {
                                                self.expandedGenreID = nil
                                            } else {
                                                self.expandedGenreID = genre.id
                                            }
                                        }
                                    }
                                )
                                .padding(.horizontal)
                                
                                // Filmek megjelenítése
                                if self.expandedGenreID == genre.id {
                                    // kinyitott állapot
                                    ExpandedMoviesGridView(genreID: genre.id)
                                        .padding(.horizontal)
                                        .padding(.top, 8)
                                } else {
                                    // Alap állapot: 3 film horizontálisan
                                    HorizontalMoviesPreviewView(genreID: genre.id, maxMoviesToShow: 3)
                                        .padding(.top, 4)
                                }
                            }
                            .padding(.bottom, 16)
                        }
                    }
                }
            }
            .navigationTitle(title)
            .accessibilityLabel(AccessibilityLabels.genreSectionCollectionView)
        }
        .showAlert(model: $viewModel.alertModel)
        .onAppear {
            viewModel.loadHighlightedMovie()
            viewModel.loadGenres()
            viewModel.genresAppeared()
        }
        .refreshable{
            await MainActor.run {
                print("REFresh")
                expandedGenreID = 0
                movieListViewModel.refreshSubject.send(())
            }
        }
    }
}
