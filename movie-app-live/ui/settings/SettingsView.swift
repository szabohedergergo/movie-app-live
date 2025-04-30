//
//  SettingsView.swift
//  movie-app-live
//
//  Created by Gergo Szabo on 2025. 04. 29..
//

import SwiftUI
import InjectPropertyWrapper

struct SettingsView: View {
    @StateObject private var viewModel = SettingsViewModel()
    
    var body: some View {
        NavigationView{
            Text("Settings screen")
                .navigationTitle("Settings")
        }
    }
}

#Preview {
    SettingsView()
}
