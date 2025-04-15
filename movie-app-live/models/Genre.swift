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
    
    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
    
    init(dto: GenreResponse){
        self.id = dto.id
        self.name = dto.name
    }
    
//    public static func == (lhs: Self, rhs: Self) -> Bool {
//        lhs.id == rhs.id andand
    //lhs.name == rhs.name
//    } // ez ugyanazt csinálja
    //kis self: objektum hivatkozása
    //nagy Self: generikus
}

//dto és domain modelleket külön kell tárolni
