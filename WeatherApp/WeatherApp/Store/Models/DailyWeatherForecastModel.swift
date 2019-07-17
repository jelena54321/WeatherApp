//
//  WeatherConfiguration.swift
//  WeatherApp
//

import Foundation

class DailyWeatherForecastModel: Decodable {
    
    let city: String
    let minTemperature: Double
    let maxTemperature: Double
    let weatherIcon: URL?
    
    enum DailyWeatherForcastCodingKeys: String, CodingKey {
        case city = "name"
        case weather
        case main
    }
    
    enum WeatherCodingKeys: String, CodingKey {
        case weatherIcon = "icon"
    }
    
    enum MainCodingKeys: String, CodingKey {
        case minTemperature = "temp_min"
        case maxTemperature = "temp_max"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DailyWeatherForcastCodingKeys.self)
        city = try container.decode(String.self, forKey: .city)
        
        var weatherContainer = try container.nestedUnkeyedContainer(forKey: .weather)
        let weather = try weatherContainer.nestedContainer(keyedBy: WeatherCodingKeys.self)
        weatherIcon = URL(
            string: String(
                format: WeatherConstants.weatherIconUrl,
                try weather.decode(String.self, forKey: .weatherIcon)
            )
        )
        
        let mainContainer = try container.nestedContainer(keyedBy: MainCodingKeys.self, forKey: .main)
        minTemperature = try mainContainer.decode(Double.self, forKey: .minTemperature)
        maxTemperature = try mainContainer.decode(Double.self, forKey: .maxTemperature)
    }
    
    init(from dailyWeatherForecast: DailyWeatherForecast) {
        city = dailyWeatherForecast.city
        minTemperature = dailyWeatherForecast.minTemperature
        maxTemperature = dailyWeatherForecast.maxTemperature
        
        if let weatherIcon = dailyWeatherForecast.weatherIcon {
            self.weatherIcon = URL(string: weatherIcon)
        } else {
            self.weatherIcon = nil
        }
    }

}
