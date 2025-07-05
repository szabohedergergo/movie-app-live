import SwiftUI
import Shimmer

struct HorizontalMoviesPreviewView: View {
    let genreID: Int
    let maxMoviesToShow: Int
    @StateObject private var mediaListViewModel = MediaItemListViewModel()

    let movieCellWidth: CGFloat = 190 //width
    let cellSpacing: CGFloat = 10
    let expectedCellHeight: CGFloat = 220

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: cellSpacing) {
                ForEach(mediaListViewModel.movies.prefix(maxMoviesToShow)) { movie in
                    return MediaItemCell(movie: movie)
                        .frame(width: movieCellWidth)
                }
            }
            .padding(.horizontal)
        }
        .frame(height: expectedCellHeight)
        .onAppear {
            mediaListViewModel.genreIdSubject.send(genreID)
        }
    }
}
