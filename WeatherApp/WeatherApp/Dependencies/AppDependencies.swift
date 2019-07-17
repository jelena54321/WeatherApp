//
//  AppDependencies.swift
//  WeatherApp
//

import Foundation

class AppDependencies {
    
    let citiesWeatherForecastService: CitiesWeatherForecastService
    let cityWeatherForecastService: CityWeatherForecastService
    let store: Store
    
    init() {
        let sessionService = SessionService()
        store = Store(
            dataController: DataController(),
            notificationCenter: NotificationCenter.default
        )
        
        citiesWeatherForecastService = CitiesWeatherForecastService(sessionService: sessionService)
        cityWeatherForecastService = CityWeatherForecastService(sessionService: sessionService)
    }
}
