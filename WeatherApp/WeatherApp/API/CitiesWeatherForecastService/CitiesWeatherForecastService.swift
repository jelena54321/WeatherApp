//
//  CitiesWeatherForecastService.swift
//  WeatherApp
//

import RxSwift

class CitiesWeatherForecastService {
    
    private static let weatherUrl = "https://api.openweathermap.org/data/2.5/group"
    
    private let sessionService: SessionService
    
    init(sessionService: SessionService) {
        self.sessionService = sessionService
    }
        
    func fetchCitiesWeatherForecast() -> Observable<Result<[DailyWeatherForecastModel], APIError>> {
        return
            sessionService.request(
                urlString: CitiesWeatherForecastService.weatherUrl,
                parameters: [
                    JSONKey.id: JSONValue.groupId,
                    JSONKey.appId: AppConstants.appId,
                    JSONKey.units: JSONValue.metric
                ]
            )
            .map { result -> Result<[DailyWeatherForecastModel], APIError> in
                if case .failure(let error) = result {
                    return .failure(error)
                }
            
                let json: Any
                do {
                    json = try JSONSerialization.jsonObject(with: try result.get(), options: [])
                } catch {
                    return .failure(APIError.serializationError)
                }
                
                guard let parsedData = CitiesWeatherForecastService.parseCities(json: json) else {
                    return .failure(APIError.parseError)
                }
                
                return .success(parsedData)
            }
    }
    
    private static func parseCities(json: Any) -> [DailyWeatherForecastModel]? {
        guard let jsonDictionary = json as? [String: Any],
              let list = jsonDictionary[JSONKey.list] as? [[String: Any]] else {
            
            return nil
        }
        
        var cities: [DailyWeatherForecastModel] = []
        let jsonDecoder = JSONDecoder()
        for city in list {
            if
                let cityData = try? JSONSerialization.data(withJSONObject: city, options: []),
                let decodedCity = try? jsonDecoder.decode(DailyWeatherForecastModel.self, from: cityData)
            {
               
                cities.append(decodedCity)
            } else {
                return nil
            }
        }
        
        return cities
    }
}
