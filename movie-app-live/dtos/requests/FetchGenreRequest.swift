//
//  FetchGenreRequest.swift
//  movie-app-live
//
//  Created by Gergo Szabo on 2025. 04. 12..
//
//név: konvenció: Request/Response

struct FetchGenreRequest{
    let accessToken: String = Config.bearerToken //környezeti / konfig változó
    
    func asRequestParams() -> [String: String]{ //dictionary, kulcs érték pár
        return [:] //return empty dictionary
    }
}
