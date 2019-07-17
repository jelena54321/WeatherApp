//
//  AppCoordinator.swift
//  WeatherApp
//

import Foundation
import RxSwift

class AppCoordinator: Coordinator {
    
    private var disposeBag = DisposeBag()
    private var window: UIWindow!
    private let navigationController: UINavigationController!
    
    private var appDependencies: AppDependencies!
    
    init(window: UIWindow) {
        navigationController = UINavigationController()
        appDependencies = AppDependencies()
        
        presentInWindow(window: window)
    }
    
    private func presentInWindow(window: UIWindow) {
        self.window = window
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
    
    func start() {
        navigationController.isNavigationBarHidden = true
        presentCitiesWeatherForecastScreen()
    }
    
    private func presentCitiesWeatherForecastScreen() {
        let citiesWeatherForecastViewController = CitiesWeatherForecastViewController(
            viewModel: CitiesWeatherForecastViewModel(
                store: appDependencies.store,
                citiesWeatherForecastService: appDependencies.citiesWeatherForecastService)
        )
        
        navigationController.pushViewController(
            citiesWeatherForecastViewController,
            animated: true
        )
        
        citiesWeatherForecastViewController
            .citySelected
            .asObservable()
            .subscribe(onNext: { [weak self] city in
                self?.presentCityWeatherForecastScreen(forCity: city)
            })
            .disposed(by: citiesWeatherForecastViewController.disposeBag)
    }
    
    private func presentCityWeatherForecastScreen(forCity city: String) {
        let viewModel = CityWeatherForecastViewModel(
            city: city,
            store: appDependencies.store,
            cityWeatherForecastService: appDependencies.cityWeatherForecastService
        )
        let cityWeatherForecastViewController = CityWeatherForecastViewController(
            viewModel: viewModel
        )
        navigationController.pushViewController(
            cityWeatherForecastViewController,
            animated: true
        )
        
        cityWeatherForecastViewController
            .backButtonTapped
            .asObservable()
            .subscribe(onNext: { [weak self] in
                self?.navigationController.popViewController(animated: true)
            })
            .disposed(by: cityWeatherForecastViewController.disposeBag)
        
        viewModel
            .dataCouldNotBeFetched
            .asObservable()
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(onNext: { _ in
                let alertController = UIAlertController(
                    title: "Error",
                    message: "Sorry, weather forecast for provided city could not be fetched",
                    preferredStyle: .alert
                )
                alertController.addAction(
                    UIAlertAction(
                        title: "OK",
                        style: .default,
                        handler: { [weak self] _ in
                            self?.navigationController.popViewController(animated: true)
                    })
                )
                
                cityWeatherForecastViewController.present(
                    alertController,
                    animated: true,
                    completion: nil
                )
            })
            .disposed(by: cityWeatherForecastViewController.disposeBag)
    }
}
