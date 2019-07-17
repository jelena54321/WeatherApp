//
//  WeatherForecastModel.swift
//  WeatherApp
//

import Foundation

class WeatherForecastModel: Decodable {
    
    private static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = WeatherConstants.dateFormatString
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        return dateFormatter
    }()
    
    let city: String
    let temperature: Double
    let minTemperature: Double
    let maxTemperature: Double
    let pressure: Double
    let humidity: Int
    let weatherIcon: URL?
    let weatherDescription: String
    let windSpeed: Double
    let timestamp: Date
    let futureForecasts: [FutureWeatherForecastModel]
    
    enum WeatherForecastModelCodingKeys: String, CodingKey {
        case list
        case city
    }
    
    enum CityCodingKeys: String, CodingKey {
        case city = "name"
    }
    
    enum ListElementCodingKeys: String, CodingKey {
        case main
        case weather
        case wind
        case timestamp = "dt_txt"
    }
    
    enum WeatherCodingKeys: String, CodingKey {
        case weatherIcon = "icon"
        case weatherDescription = "description"
    }
    
    enum MainCodingKeys: String, CodingKey {
        case temperature = "temp"
        case minTemperature = "temp_min"
        case maxTemperature = "temp_max"
        case pressure
        case humidity
    }
    
    enum WindCodingKeys: String, CodingKey {
        case windSpeed = "speed"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: WeatherForecastModelCodingKeys.self)
        
        let cityContainer = try container.nestedContainer(keyedBy: CityCodingKeys.self, forKey: .city)
        city = try cityContainer.decode(String.self, forKey: .city)
        
        var listContainer = try container.nestedUnkeyedContainer(forKey: .list)
        let listElement = try listContainer.nestedContainer(keyedBy: ListElementCodingKeys.self)
        
        timestamp = WeatherForecastModel.dateFormatter.date(
            from: try listElement.decode(String.self, forKey: .timestamp)
        )!
        
        let mainContainer = try listElement.nestedContainer(keyedBy: MainCodingKeys.self, forKey: .main)
        temperature = try mainContainer.decode(Double.self, forKey: .temperature)
        minTemperature = try mainContainer.decode(Double.self, forKey: .minTemperature)
        maxTemperature = try mainContainer.decode(Double.self, forKey: .maxTemperature)
        pressure = try mainContainer.decode(Double.self, forKey: .pressure)
        humidity = try mainContainer.decode(Int.self, forKey: .humidity)
        
        var weatherContainer = try listElement.nestedUnkeyedContainer(forKey: .weather)
        let weather = try weatherContainer.nestedContainer(keyedBy: WeatherCodingKeys.self)
        weatherDescription = try weather.decode(String.self, forKey: .weatherDescription)
        weatherIcon = URL(
            string: String(
                format: WeatherConstants.weatherIconUrl,
                try weather.decode(String.self, forKey: .weatherIcon)
            )
        )
        
        let windContainer = try listElement.nestedContainer(keyedBy: WindCodingKeys.self, forKey: .wind)
        windSpeed = try windContainer.decode(Double.self, forKey: .windSpeed)
        
        var futureForecasts: [FutureWeatherForecastModel] = []
        while !listContainer.isAtEnd {
            let futureForecast = try listContainer.decode(FutureWeatherForecastModel.self)
            if WeatherForecastModel.isSameDay(
                firstDate: timestamp,
                secondDate: futureForecast.timestamp
            ) { continue }
            if !WeatherForecastModel.isNoon(date: futureForecast.timestamp) { continue }
            
            futureForecasts.append(futureForecast)
        }
        
        self.futureForecasts = futureForecasts
    }
    
    init(from weatherForecast: WeatherForecast) {
        city = weatherForecast.city
        temperature = weatherForecast.temperature
        minTemperature = weatherForecast.minTemperature
        maxTemperature = weatherForecast.maxTemperature
        pressure = weatherForecast.pressure
        humidity = Int(weatherForecast.humidity)
        weatherDescription = weatherForecast.weatherDescription
        windSpeed = weatherForecast.windSpeed
        futureForecasts = weatherForecast.futureForecasts.map {
            FutureWeatherForecastModel(from: $0)
        }
        
        if let weatherIcon = weatherForecast.weatherIcon {
             self.weatherIcon = URL(string: weatherIcon)
        } else {
            self.weatherIcon = nil
        }
        
        timestamp = Date(
            timeIntervalSinceReferenceDate: weatherForecast.timestamp.timeIntervalSinceReferenceDate
        )
    }
    
    private static func isSameDay(firstDate: Date, secondDate: Date) -> Bool {
        return
            Calendar.current.dateComponents([.day], from: firstDate) ==
            Calendar.current.dateComponents([.day], from: secondDate)
    }
    
    private static func isNoon(date: Date) -> Bool {
        return Calendar.current.component(.hour, from: date) == WeatherConstants.noon
    }
}
