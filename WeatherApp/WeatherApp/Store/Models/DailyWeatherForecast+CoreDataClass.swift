//
//  DailyWeatherForecast+CoreDataClass.swift
//  
//
//  Created by Jelena Šarić on 08/07/2019.
//
//

import Foundation
import CoreData

@objc(DailyWeatherForecast)
public class DailyWeatherForecast: NSManagedObject {
    
    static let cityPredicate = "city = %@"
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<DailyWeatherForecast> {
        return NSFetchRequest<DailyWeatherForecast>(entityName: AppConstants.dailyWeatherForecast)
    }
    
    static func fetchOrCreate(byCity city: String) -> DailyWeatherForecast? {
        let context = DataController.shared.persistentContainer.viewContext
        
        let request: NSFetchRequest<DailyWeatherForecast> = DailyWeatherForecast.fetchRequest()
        request.predicate = NSPredicate(format: DailyWeatherForecast.cityPredicate, city)
        request.returnsObjectsAsFaults = false
        
        do {
            let weatherForcasts = try context.fetch(request)
            return weatherForcasts.first ?? DailyWeatherForecast(context: context)
        } catch {
            return nil
        }
    }
    
    static func update(using model: DailyWeatherForecastModel) -> DailyWeatherForecast? {
        guard let weatherForecast = fetchOrCreate(byCity: model.city) else {
            return nil
        }
        
        weatherForecast.dataCalculation = Int64(model.dataCalculation)
        weatherForecast.minTemperature = model.minTemperature
        weatherForecast.maxTemperature = model.maxTemperature
        weatherForecast.weatherIcon = model.weatherIcon?.absoluteString
        
        do {
            try DataController.shared.persistentContainer.viewContext.save()
        } catch {
            return nil
        }
        
        return weatherForecast
    }

}
