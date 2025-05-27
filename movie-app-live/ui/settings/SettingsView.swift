//
//  SettingsView.swift
//  movie-app-live
//
//  Created by Gergo Szabo on 2025. 04. 29..
//

import SwiftUI

struct SettingsView: View {
    @StateObject private var viewModel = SettingsViewModel()
    
    var body: some View {
        VStack{
            Text("Settings")
                .font(Fonts.title)
            
            Text("Choose Language")
                .font(Fonts.caption)
            
            HStack{
                StyledButton(style: viewModel.selectedLanguage.value == "en" ? .filled : .outlined, action: .simple, title: "English")
                    .onTapGesture {
                        viewModel.selectedLanguage.send("en")
                    }
                
                StyledButton(style: viewModel.selectedLanguage.value == "de" ? .filled : .outlined, action: .simple, title: "Deutsche")
                    .onTapGesture {
                        viewModel.selectedLanguage.send("de")
                    }
                
                StyledButton(style: viewModel.selectedLanguage.value == "hu" ? .filled : .outlined, action: .simple, title: "Hungarian")
                    .onTapGesture {
                        viewModel.selectedLanguage.send("hu")
                    }
            }
            
            Text("Choose the dark or light side")
                .font(Fonts.caption)
            
            HStack{
                StyledButton(style: viewModel.selectedTheme.value == "light" ? .filled : .outlined, action: .simple, title: "Light side")
                    .onTapGesture {
                        viewModel.selectedTheme.send("light")
                    }
                
                StyledButton(style: viewModel.selectedTheme.value == "dark" ? .filled : .outlined, action: .simple, title: "Dark side")
                    .onTapGesture {
                        viewModel.selectedTheme.send("dark")
                    }
                

            }
            
            Text("version: 0.9.1")
                .font(Fonts.caption)
            Text("created by G")
                .font(Fonts.caption)
        }
    }
}
