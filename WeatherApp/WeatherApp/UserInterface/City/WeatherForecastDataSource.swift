//
//  WeatherDetailsSection.swift
//  WeatherApp
//

import RxDataSources

struct WeatherForecastDetailModel {
    
    let weatherDetail: String
    let weatherDetailValue: String
    
    init(weatherDetail: String, weatherDetailValue: String) {
        self.weatherDetail = weatherDetail
        self.weatherDetailValue = weatherDetailValue
    }
}

enum WeatherForecastCellModel {
    case futureWeatherForecast(FutureWeatherForecastModel)
    case weatherForecastDetail(WeatherForecastDetailModel)
}

struct WeatherForecastSection {
    var items: [Item]
}

extension WeatherForecastSection: SectionModelType {
    typealias Item = WeatherForecastCellModel
    
    init(original: WeatherForecastSection, items: [Item]) {
        self = original
        self.items = items
    }
}
