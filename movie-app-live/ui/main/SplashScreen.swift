//
//  SplashScreen.swift
//  movie-app-live
//
//  Created by Gergo Szabo on 2025. 05. 31..
//

import SwiftUI
import Lottie

struct SplashScreen: View {
    @State var animationFinished: Bool = false
    
    @State var selectedTab: TabType = TabType.genre
    
    var body: some View {
        if animationFinished {
            RootView(selectedTab: selectedTab)
        }
        else{
//            LottieView {
//                let fileURL = Bundle.main.url(forResource: "movies", withExtension: "json")!
//                return await LottieAnimation
//                    .loadedFrom(url: fileURL)
//            }
            LottieView (animation: .named("movies"))
                .playing(loopMode: .playOnce)
                //.animationSpeed(5.0)
                .animationDidFinish { finished in
                    animationFinished.toggle()
                }
        }
    }
}
