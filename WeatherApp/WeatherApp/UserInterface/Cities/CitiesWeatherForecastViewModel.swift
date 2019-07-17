//
//  CitiesWeatherForecastViewModel.swift
//  WeatherApp
//

import RxSwift
import RxCocoa

class CitiesWeatherForecastViewModel {
    
    let refreshData = PublishSubject<Void>()
    var citiesWeatherForecast: Observable<[DailyWeatherForecastModel]>!
    let fetchingIndicator = PublishSubject<Bool>()
    
    private let store: Store
    private let citiesWeatherForecastService: CitiesWeatherForecastService
    
    init(store: Store, citiesWeatherForecastService: CitiesWeatherForecastService) {
        self.store = store
        self.citiesWeatherForecastService = citiesWeatherForecastService
        
        configure()
    }
        
    private func configure() {
        citiesWeatherForecast = Observable.merge(refreshData.asObservable(), Observable.just(()))
            .flatMap { [weak self] _ -> Observable<Result<[DailyWeatherForecastModel], APIError>> in
                guard let self = self else { return Observable.empty() }
                self.fetchingIndicator.onNext(true)
                return self.citiesWeatherForecastService.fetchCitiesWeatherForecast()
            }
            .flatMap { [weak self] result -> Observable<[DailyWeatherForecastModel]> in
                guard let self = self else { return Observable.empty() }
                self.fetchingIndicator.onNext(false)
                
                switch result {
                case .success(let data):
                    return self.store.update(dailyWeatherForcasts: data, into: .main)
                case .failure(_):
                    return self.store.fetchDailyWeatherForecast(fromContext: .main)
                }
            }
    }
    
}
