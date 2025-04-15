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
        case tvlist
    }
#if ENV_PROD
    static let name: Name = .prod
#elseif ENV_DEV
    static let name: Name = .dev
#else
    static let name: Name = .tvlist
#endif
}
