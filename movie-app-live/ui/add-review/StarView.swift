//
//  StarView.swift
//  movie-app-live
//
//  Created by Gergo Szabo on 2025. 05. 24..
//

import SwiftUI

struct StarView: View {
    let index: Int
    let isFilled: Bool
    var size: CGFloat = 40.0
    let onTap: () -> Void

    var body: some View {
        Image(isFilled ? .star : .star)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: size, height: size)
            .onTapGesture {
                onTap()
            }
    }
    
    
}
