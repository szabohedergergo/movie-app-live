//
//  Environments.swift
//  movie-app-live
//
//  Created by Gergo Szabo on 2025. 04. 12..
//

struct Environments{
    enum Name{
        case prod
        case dev
    }
#if ENV_PROD
    static let name: Name = .prod
#else
    static let name: Name = .dev
#endif
}
