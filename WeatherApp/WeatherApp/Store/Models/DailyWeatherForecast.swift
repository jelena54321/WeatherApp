//
//  DailyWeatherForecast+CoreDataProperties.swift
//  WeatherApp
//

import CoreData

@objc(DailyWeatherForecast)
public class DailyWeatherForecast: NSManagedObject {

    @NSManaged public var city: String
    @NSManaged public var maxTemperature: Double
    @NSManaged public var minTemperature: Double
    @NSManaged public var weatherIcon: String?
    
}

extension DailyWeatherForecast {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<DailyWeatherForecast> {
        return NSFetchRequest<DailyWeatherForecast>(entityName: "DailyWeatherForecast")
    }
    
    func populate(withModel model: DailyWeatherForecastModel) {
        city = model.city
        maxTemperature = model.maxTemperature
        minTemperature = model.minTemperature
        weatherIcon = model.weatherIcon?.absoluteString
    }
    
}
