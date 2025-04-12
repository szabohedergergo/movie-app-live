//
//  Genre.swift
//  movie-app-live
//
//  Created by Gergo Szabo on 2025. 04. 08..
//
//akkor equatable, ha minden propertyje ugyanaz
struct Genre: Decodable, Identifiable, Hashable, Equatable {
    let id: Int
    let name: String
    
//    public static func == (lhs: Self, rhs: Self) -> Bool {
//        lhs.id == rhs.id andand
    //lhs.name == rhs.name
//    } // ez ugyanazt csinálja
    //kis self: objektum hivatkozása
    //nagy Self: generikus
}
