import SwiftUI

struct ParticipantCell: View {
    let imageUrl: URL?
    let title: String
    let participant: ParticipantItemProtocol
    
    var body: some View {
        NavigationLink(destination: ParticipantDetailView(participant: participant)) {
            VStack(alignment: .leading, spacing: 12.0) {
                LoadImageView(url: imageUrl)
                    .frame(width: 56, height: 56)
                    .cornerRadius(28)
                
                Text(title)
                    .font(Fonts.subheading)
                    .lineLimit(nil)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: 100.0)
        }
        .buttonStyle(PlainButtonStyle())
    }
} 