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
    let onTap: () -> Void

    var body: some View {
        //Image(isFilled ? .starFilled : .starUnfilled)
        Image(isFilled ? .star : .star)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 40.0, height: 40.0)
            .onTapGesture {
                onTap()
            }
    }
    
    
}
