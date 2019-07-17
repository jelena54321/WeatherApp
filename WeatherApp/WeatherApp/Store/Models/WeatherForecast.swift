//
//  WeatherForecast+CoreDataClass.swift
//  WeatherApp
//

import CoreData

@objc(WeatherForecast)
public class WeatherForecast: NSManagedObject {
    
    @NSManaged public var city: String
    @NSManaged public var humidity: Int64
    @NSManaged public var temperature: Double
    @NSManaged public var minTemperature: Double
    @NSManaged public var maxTemperature: Double
    @NSManaged public var pressure: Double
    @NSManaged public var weatherIcon: String?
    @NSManaged public var weatherDescription: String
    @NSManaged public var windSpeed: Double
    @NSManaged public var timestamp: NSDate
    @NSManaged public var futureForecasts: Set<FutureWeatherForecast>
    
}

extension WeatherForecast {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<WeatherForecast> {
        return NSFetchRequest<WeatherForecast>(entityName: "WeatherForecast")
    }
    
    func populate(withModel model: WeatherForecastModel) {
        city = model.city
        humidity = Int64(model.humidity)
        temperature = model.temperature
        minTemperature = model.minTemperature
        maxTemperature = model.maxTemperature
        pressure = model.pressure
        weatherDescription = model.weatherDescription
        weatherIcon = model.weatherIcon?.absoluteString
        windSpeed = model.windSpeed
        timestamp = NSDate(timeInterval: 0, since: model.timestamp)
    }

}
