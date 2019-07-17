//
//  FutureWeatherForecastModel.swift
//  WeatherApp
//

import Foundation

class FutureWeatherForecastModel: Decodable {
    
    private static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = WeatherConstants.dateFormatString
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        return dateFormatter
    }()
    
    let timestamp: Date
    let weatherIcon: URL?
    let maxTemperature: Double
    let minTemperature: Double
    
    enum FutureWeatherForecastCodingKeys: String, CodingKey {
        case main
        case weather
        case timestamp = "dt_txt"
    }
    
    enum MainCodingKeys: String, CodingKey {
        case minTemperature = "temp_min"
        case maxTemperature = "temp_max"
    }
    
    enum WeatherCodingKeys: String, CodingKey {
        case weatherIcon = "icon"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: FutureWeatherForecastCodingKeys.self)
        
        timestamp = FutureWeatherForecastModel.dateFormatter.date(
            from: try container.decode(String.self, forKey: .timestamp)
        )!
        
        let mainContainer = try container.nestedContainer(keyedBy: MainCodingKeys.self, forKey: .main)
        minTemperature = try mainContainer.decode(Double.self, forKey: .minTemperature)
        maxTemperature = try mainContainer.decode(Double.self, forKey: .maxTemperature)
        
        var weatherContainer = try container.nestedUnkeyedContainer(forKey: .weather)
        let weather = try weatherContainer.nestedContainer(keyedBy: WeatherCodingKeys.self)
        weatherIcon = URL(
            string: String(
                format: WeatherConstants.weatherIconUrl,
                try weather.decode(String.self, forKey: .weatherIcon)
            )
        )
    }
    
    init(from futureWeatherForecast: FutureWeatherForecast) {
        timestamp = Date(
            timeIntervalSinceReferenceDate: futureWeatherForecast.timestamp.timeIntervalSinceReferenceDate
        )
        minTemperature = futureWeatherForecast.minTemperature
        maxTemperature = futureWeatherForecast.maxTemperature
        
        if let weatherIcon = futureWeatherForecast.weatherIcon {
            self.weatherIcon = URL(string: weatherIcon)
        } else {
            self.weatherIcon = nil
        }
    }

}
