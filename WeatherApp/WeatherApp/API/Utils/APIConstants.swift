//
//  APIError.swift
//  WeatherApp
//

enum APIError: Error {
    case parseError
    case statusCodeError(Int)
    case serializationError
    case couldNotReferenceSelf
    case noInternetConnection
    case couldNotDecodeData
    case unknownError
}

enum HttpResponse: Int {
    case UNAUTORIZED = 401
    case FORBIDDEN = 403
    case NOT_FOUND = 404
    case BAD_REQUEST = 400
    case OK = 200
    case SERVICE_UNAVAILABLE = 503
}
