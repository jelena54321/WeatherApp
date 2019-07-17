//
//  FutureWeatherForecast+CoreDataProperties.swift
//  WeatherApp
//

import CoreData

@objc(FutureWeatherForecast)
public class FutureWeatherForecast: NSManagedObject {

    @NSManaged public var timestamp: NSDate
    @NSManaged public var weatherIcon: String?
    @NSManaged public var minTemperature: Double
    @NSManaged public var maxTemperature: Double

}

extension FutureWeatherForecast {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<FutureWeatherForecast> {
        return NSFetchRequest<FutureWeatherForecast>(entityName: "FutureWeatherForecast")
    }
    
    func populate(withModel model: FutureWeatherForecastModel) {
        timestamp = NSDate(timeInterval: 0, since: model.timestamp)
        weatherIcon = model.weatherIcon?.absoluteString
        minTemperature = model.minTemperature
        maxTemperature = model.maxTemperature
    }
    
}
