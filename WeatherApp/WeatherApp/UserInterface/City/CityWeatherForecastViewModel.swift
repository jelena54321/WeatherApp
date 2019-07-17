//
//  CityWeatherForecastViewModel.swift
//  WeatherApp
//

import RxSwift
import RxCocoa

class CityWeatherForecastViewModel {
    
    let dataCouldNotBeFetched = PublishSubject<Void>()
    var cityWeatherForecast: Observable<WeatherForecastModel>!
    var sections: Observable<[WeatherForecastSection]>!
    var city: String
    
    private let store: Store
    private let cityWeatherForecastService: CityWeatherForecastService
    
    private let disposeBag = DisposeBag()
    
    init(city: String, store: Store, cityWeatherForecastService: CityWeatherForecastService) {
        self.city = city
        self.store = store
        self.cityWeatherForecastService = cityWeatherForecastService
        
        configure()
    }
        
    private func configure() {
        let data = Observable.just(())
            .flatMap { [weak self] _ -> Observable<Result<Int, APIError>> in
                guard let self = self else { return Observable.empty() }
                return self.cityWeatherForecastService.fetchCityId(forCity: self.city)
            }
            .flatMap { [weak self] result -> Observable<Result<WeatherForecastModel, APIError>> in
                guard let self = self else { return Observable.empty() }
                switch result {
                case .success(let cityId):
                    return self.cityWeatherForecastService.fetchWeatherForecast(forCityId: cityId)
                case .failure(let error):
                    if
                        case APIError.statusCodeError(let code) = error,
                        code == HttpResponse.NOT_FOUND.rawValue {
                        
                        self.dataCouldNotBeFetched.onNext(())
                        return Observable.empty()
                    }
                    
                    return Observable.just(.failure(error))
                }
            }
            .flatMap { [weak self] result -> Observable<WeatherForecastModel> in
                guard let self = self else { return Observable.empty() }
                switch result {
                case .success(let data):
                    return self.store.update(weatherForecast: data, into: .main)
                case .failure(_):
                    return self.store.fetchWeatherForecast(forCity: self.city, fromContext: .main)
                }
            }
            .catchError { [weak self] _ -> Observable<WeatherForecastModel> in
                self?.dataCouldNotBeFetched.onNext(())
                return Observable.empty()
            }
        
        cityWeatherForecast = data
        sections = data
            .flatMap { [weak self] forecast -> Observable<[WeatherForecastSection]> in
                guard let self = self else { return Observable.empty() }
                return self.configureSections(weatherForecast: forecast)
        }
    }
    
    func configureSections(weatherForecast: WeatherForecastModel) -> Observable<[WeatherForecastSection]> {
        var futureForecastSectionItems: [WeatherForecastCellModel] = []
        for futureForecast in weatherForecast.futureForecasts {
            futureForecastSectionItems.append(.futureWeatherForecast(futureForecast))
        }
        
        let weatherForecastDetailSectionItems = [
            WeatherForecastCellModel.weatherForecastDetail(
                WeatherForecastDetailModel(
                    weatherDetail: "MIN TEMPERATURE",
                    weatherDetailValue: String(
                        format: "%.1f ºC",
                        weatherForecast.minTemperature
                    )
            )),
            WeatherForecastCellModel.weatherForecastDetail(
                WeatherForecastDetailModel(
                    weatherDetail: "MAX TEMPERATURE",
                    weatherDetailValue: String(
                        format: "%.1f ºC",
                        weatherForecast.maxTemperature
                    )
            )),
            WeatherForecastCellModel.weatherForecastDetail(
                WeatherForecastDetailModel(
                    weatherDetail: "HUMIDITY",
                    weatherDetailValue: String(
                        format: "%d%@",
                        weatherForecast.humidity,
                        "%"
                    )
            )),
            WeatherForecastCellModel.weatherForecastDetail(
                WeatherForecastDetailModel(
                    weatherDetail: "PRESSURE",
                    weatherDetailValue: String(
                        format: "%.0f hPa",
                        weatherForecast.pressure
                    )
            )),
            WeatherForecastCellModel.weatherForecastDetail(
                WeatherForecastDetailModel(
                    weatherDetail: "WIND SPEED",
                    weatherDetailValue: String(
                        format: "%.1f mps",
                        weatherForecast.windSpeed
                    )
            ))
        ]
        
        return Observable.just([
            WeatherForecastSection(items: futureForecastSectionItems),
            WeatherForecastSection(items: weatherForecastDetailSectionItems)
        ])
    }

}
