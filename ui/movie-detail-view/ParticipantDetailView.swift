import SwiftUI

struct ParticipantDetailView: View {
    let participant: ParticipantItemProtocol
    @StateObject private var viewModel = DetailViewModel()
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: LayoutConst.largePadding) {
                LoadImageView(url: participant.imageUrl)
                    .frame(height: 180)
                    .frame(maxWidth: .infinity)
                    .cornerRadius(30)
                
                Text(participant.name)
                    .font(Fonts.detailsTitle)
                
                if let mediaItemDetail = viewModel.mediaItemDetail {
                    HStack(spacing: 12.0) {
                        MovieLabel(type: .rating(mediaItemDetail.rating))
                        MovieLabel(type: .voteCount(mediaItemDetail.voteCount))
                        MovieLabel(type: .popularity(mediaItemDetail.popularity))
                        Spacer()
                        MovieLabel(type: .adult(mediaItemDetail.adult))
                    }
                    
                    Text(mediaItemDetail.genreList)
                        .font(Fonts.paragraph)
                    
                    MediaItemHeaderView(title: mediaItemDetail.title,
                                      year: mediaItemDetail.year,
                                      runtime: "\(mediaItemDetail.runtime)",
                                      spokenLanguages: mediaItemDetail.spokenLanguages)
                    
                    VStack(alignment: .leading, spacing: 12.0) {
                        Text(LocalizedStringKey("detail.overview"))
                            .font(Fonts.overviewText)
                        
                        Text(mediaItemDetail.overview)
                            .font(Fonts.paragraph)
                            .lineLimit(nil)
                    }
                }
            }
            .padding(.horizontal, LayoutConst.maxPadding)
            .padding(.bottom, LayoutConst.largePadding)
        }
        .showAlert(model: $viewModel.alertModel)
        .onAppear {
            viewModel.participantIdSubject.send(participant.id)
        }
    }
}