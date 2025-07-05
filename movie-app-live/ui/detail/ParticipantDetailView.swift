//// ParticipantDetailView.swift
////  movie-app-live
////
////  Created by Gergo Szabo on 2025. 06. 13..
////
//
//import SwiftUI
//
//struct ParticipantDetailView: View {
//    let participantId: Int
//    let participantType: ParticipantType // Ezt adjuk át, hogy tudjuk, személyről vagy cégről van szó
//    
//    @StateObject private var viewModel = ParticipantDetailViewModel() // Az új ViewModel
//    @Environment(\.dismiss) private var dismiss: DismissAction // Hogy vissza tudjunk menni
//
//    var body: some View {
//        ScrollView {
//            VStack(alignment: .leading, spacing: LayoutConst.largePadding) {
//                // Kép
//                LoadImageView(url: viewModel.participantDetail?.imageUrl) // Kép az új modellből
//                    .frame(height: 180)
//                    .frame(maxWidth: .infinity)
//                    .cornerRadius(30)
//                
//                // Név
//                Text(viewModel.participantDetail?.name ?? "Ismeretlen") // Név az új modellből
//                    .font(Fonts.detailsTitle)
//                
//                // Részletes infók (születési dátum, hely vagy alapítási év, ország)
//                VStack(alignment: .leading, spacing: LayoutConst.smallPadding) {
//                    if let detail = viewModel.participantDetail {
//                        switch detail {
//                        case .person(let person):
//                            HStack {
//                                Text("Született:").font(Fonts.subheading)
//                                Text(person.birthday).font(Fonts.paragraph)
//                            }
//                            HStack {
//                                Text("Születési hely:").font(Fonts.subheading)
//                                Text(person.placeOfBirth).font(Fonts.paragraph)
//                            }
//                            HStack {
//                                Text("Népszerűség:").font(Fonts.subheading)
//                                Text(String(format: "%.1f", person.popularity)).font(Fonts.paragraph)
//                            }
//                        case .company(let company):
//                            HStack {
//                                Text("Származási ország:").font(Fonts.subheading)
//                                Text(company.originCountry).font(Fonts.paragraph)
//                            }
//                            if let homepage = company.homepage {
//                                Link("Honlap", destination: homepage)
//                                    .font(Fonts.paragraph)
//                                    .foregroundColor(.blue)
//                            }
//                        }
//                    }
//                }
//                .padding(.vertical, LayoutConst.smallPadding)
//
//                // Bio / Leírás
//                VStack(alignment: .leading, spacing: 12.0) {
//                    Text(LocalizedStringKey(participantType == .person ? "detail.biography" : "detail.description")) // Cím
//                        .font(Fonts.overviewText)
//                    
//                    Text(viewModel.participantDetail?.descriptionText ?? "Nincs elérhető információ.") // Leírás az új modellből
//                        .font(Fonts.paragraph)
//                        .lineLimit(nil)
//                }
//            }
//            .padding(.horizontal, LayoutConst.maxPadding)
//            .padding(.bottom, LayoutConst.largePadding)
//        }
//        .showAlert(model: $viewModel.alertModel)
//        .onAppear {
//            viewModel.fetchParticipantDetail(id: participantId, type: participantType) // Adatok betöltése
//        }
//        .navigationBarTitleDisplayMode(.inline)
//        .navigationTitle(viewModel.participantDetail?.name ?? "Részletek")
//    }
//}
//
//// Kiegészítés a ParticipantDetailType-hoz, hogy könnyebb legyen elérni a display property-ket
//extension ParticipantDetailType {
//    var id: Int {
//        switch self {
//        case .person(let person): return person.id
//        case .company(let company): return company.id
//        }
//    }
//    
//    var name: String {
//        switch self {
//        case .person(let person): return person.name
//        case .company(let company): return company.name
//        }
//    }
//    
//    var imageUrl: URL? {
//        switch self {
//        case .person(let person): return person.imageUrl
//        case .company(let company): return company.imageUrl
//        }
//    }
//    
//    var descriptionText: String {
//        switch self {
//        case .person(let person): return person.biography
//        case .company(let company): return company.description
//        }
//    }
//}
//
//// Ezeket a stringeket (kulcsokat) majd hozzá kell adnod a Localizable.strings fájlba:
//// "detail.biography" = "Életrajz";
//// "detail.description" = "Leírás";
//// "Született:" = "Született:";
//// "Születési hely:" = "Születési hely:";
//// "Népszerűség:" = "Népszerűség:";
//// "Származási ország:" = "Származási ország:";
//// "Honlap" = "Honlap";
