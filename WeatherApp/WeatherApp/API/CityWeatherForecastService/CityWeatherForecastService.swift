//
//  CityWeatherForecastService.swift
//  WeatherApp
//

import RxSwift

class CityWeatherForecastService {
    
    private static let weatherUrl = "https://api.openweathermap.org/data/2.5/forecast"
    private static let cityIdUrl = "https://api.openweathermap.org/data/2.5/weather"
    
    private let sessionService: SessionService
    
    init(sessionService: SessionService) {
        self.sessionService = sessionService
    }
    
    func fetchCityId(forCity city: String) -> Observable<Result<Int, APIError>> {
        return
            sessionService.request(
                urlString: CityWeatherForecastService.cityIdUrl,
                parameters: [
                    JSONKey.appId: AppConstants.appId,
                    JSONKey.city: city
                ]
            )
            .map { result -> Result<Int, APIError> in
                if case .failure(let error) = result {
                    return .failure(error)
                }
                
                do {
                    if let cityId = try CityWeatherForecastService.parseCityId(
                        json: JSONSerialization.jsonObject(
                            with: try result.get(),
                            options: []
                        )
                    ) {
                        return .success(cityId)
                    } else {
                        return .failure(.parseError)
                    }
                } catch {
                    return .failure(.serializationError)
                }
            }.catchErrorJustReturn(.failure(.noInternetConnection))
    }
        
    func fetchWeatherForecast(forCityId cityId: Int) -> Observable<Result<WeatherForecastModel, APIError>> {
        return
            sessionService.request(
                urlString: CityWeatherForecastService.weatherUrl,
                parameters: [
                    JSONKey.id: String(cityId),
                    JSONKey.appId: AppConstants.appId,
                    JSONKey.units: JSONValue.metric
                ]
            )
            .map { result -> Result<WeatherForecastModel, APIError> in
                if case .failure(let error) = result {
                    return .failure(error)
                }
                
                do {
                    return
                        try .success(
                            JSONDecoder().decode(
                                WeatherForecastModel.self,
                                from: try result.get()
                            )
                    )
                } catch {
                    return .failure(APIError.serializationError)
                }
            }
    }
    
    private static func parseCityId(json: Any) -> Int? {
        guard
            let jsonDictionary = json as? [String: Any],
            let cityId = jsonDictionary[JSONKey.id] as? Int
        else
        {
            return nil
        }
        
        return cityId
    }
}
