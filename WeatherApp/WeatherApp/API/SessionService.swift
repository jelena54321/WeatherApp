//
//  SessionService.swift
//  WeatherApp
//

import RxSwift
import RxCocoa
import Reachability
//import RxReachability

class SessionService {
    
    private static let hostName = "api.openweathermap.org"
    
    private let urlSession: URLSession = .shared
    private let reachability = Reachability(hostname: SessionService.hostName)!
    
    func request(urlString: String,
                 parameters: [String: String]) -> Observable<Result<Data, APIError>> {
        
        var urlRequest = URLRequest(
            url: SessionService.configureUrl(urlString: urlString, parameters: parameters)
        )
        urlRequest.httpMethod = "GET"
        urlRequest.addValue(
            "application/json",
            forHTTPHeaderField: "Content-Type"
        )
        
        return
            urlSession
                .rx
                .response(request: urlRequest)
                .flatMap { (response, data) -> Observable<Result<Data, APIError>> in
                    if response.statusCode != HttpResponse.OK.rawValue {
                        return Observable.just(.failure(.statusCodeError(response.statusCode)))
                    }
                    
                    return Observable.just(.success(data))
                }
            .catchError { [weak self] _ -> Observable<Result<Data, APIError>> in
                if self?.reachability.connection == .none {
                    return Observable.just(.failure(.noInternetConnection))
                }
                
                return Observable.just(.failure(.unknownError))
            }
    }
    
    static func configureUrl(urlString: String, parameters: [String: String]) -> URL {
        var urlComponents = URLComponents(string: urlString)!
        urlComponents.queryItems = []
        for (name, value) in parameters {
            urlComponents.queryItems?.append(URLQueryItem(name: name, value: value))
        }
        
        return urlComponents.url!
    }
    
}
