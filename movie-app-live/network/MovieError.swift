//
//  MovieError.swift
//  movie-app-live
//
//  Created by Gergo Szabo on 2025. 04. 28..
//

import Foundation
import Combine

enum MovieError: Error {
    case invalidApiKeyError(message: String)
    case clientError
    case unexpectedError
    case noInternetError
    case mappingError(message: String)
    case serverError
    
    var domain: String {
        switch self {
        case .invalidApiKeyError, .unexpectedError, .clientError, .mappingError, .noInternetError, .serverError:
            return "MovieError"
        }
        
    
    }
}

extension MovieError: LocalizedError {
    
    var errorDescription: String? {
        switch self {
        case .invalidApiKeyError(let message):
            return message
        case .mappingError(let message):
            return message
        case .clientError:
            return "Client Error Description"
        case .unexpectedError:
            return "Unexpected error"
        case .noInternetError:
            return "No internet"
        case .serverError:
            return "Server Error"
        }
    }
    
}

extension MovieError: CustomNSError {
    
    var errorCode: Int {
        switch self {
        case .invalidApiKeyError(let message):
            return 1000
        case .mappingError(let message):
            return 1001
        case .clientError:
            return 1002
        case .unexpectedError:
            return 1003
        case .noInternetError:
            return 1004
        case .serverError:
            return 1005
        }
    }
    
}

extension Publisher where Failure == Error {
    func rethrowErrorAsMovieError() -> AnyPublisher<Output, MovieError> {
        self.mapError { error -> MovieError in
            let movieError = mapToMovieError(error)
            //Crashlytics.crashlytics().record(error: movieError)
            return movieError
        }
        .eraseToAnyPublisher()
    }
}

func mapToMovieError(_ error: Error) -> MovieError {
    if let movieError = error as? MovieError {
        return movieError
    }
    
    return .unexpectedError
}
