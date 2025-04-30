//
//  GlobalMethods.swift
//  movie-app-live
//
//  Created by Gergo Szabo on 2025. 04. 28..
//

import UIKit

func safeArea() -> UIEdgeInsets {
    (UIApplication.shared.connectedScenes.first as? UIWindowScene)?
        .windows.first?.safeAreaInsets ?? .zero
}
