import SwiftUI
import InjectPropertyWrapper

struct GenreSectionView: View {
    @StateObject private var viewModel = GenreSectionViewModelImpl()
    
    var body: some View {
        let title = Environments.name == .tvlist ? "TV" : "genreSection.title".localized()
        NavigationView {
            List(viewModel.genres) { genre in
                ZStack {
                    NavigationLink(destination: MovieListView(genre: genre)) {
                        EmptyView()
                    }
                    .opacity(0)

                    GenreSectionCell(genre: genre)
                }
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
            }
            .listStyle(.plain)
            .navigationTitle(title)
            .accessibilityLabel("testCollectionView")
        }
        .showAlert(model: $viewModel.alertModel)
        .onAppear{
            viewModel.loadGenres()
            viewModel.genresAppeared()
        }
    }
}

#Preview {
    GenreSectionView()
}
