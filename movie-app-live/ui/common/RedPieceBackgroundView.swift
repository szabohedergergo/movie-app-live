//
//  RedPieceBackgroundView.swift
//  movie-app-live
//
//  Created by Gergo Szabo on 2025. 07. 05..
//


import SwiftUI

struct RedPieceBackgroundView: View {
    var body: some View {
        Image(.redPiece)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 280, height: 280)
            .offset(x: 50, y: -50)
            .ignoresSafeArea(.all)
    }
}

#Preview {
    RedPieceBackgroundView()
        .previewLayout(.sizeThatFits)
        .padding()
}
