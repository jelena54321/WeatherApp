//
//  CityWeatherForecastViewController.swift
//  WeatherApp
//

import UIKit
import RxSwift
import RxDataSources

class CityWeatherForecastViewController: UIViewController {
    
    private static let throttleInterval = 0.1
    
    var backButton: UIButton!
    var cityLabel: UILabel!
    var weatherDescriptionLabel: UILabel!
    var weatherIconImageView: UIImageView!
    var temperatureLabel: UILabel!
    var weatherDetailsTableView: UITableView!

    private var viewModel: CityWeatherForecastViewModel!
    
    let backButtonTapped = PublishSubject<Void>()
    let disposeBag = DisposeBag()
    
    convenience init(viewModel: CityWeatherForecastViewModel) {
        self.init()
        self.viewModel = viewModel
    }
    
    override func loadView() {
        buildViews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureInterface()
        configureTableView()
    }
    
    private func configureInterface() {
        viewModel.cityWeatherForecast
            .subscribe(onNext: { [weak self] forecast in
                self?.cityLabel.text = forecast.city
                self?.weatherDescriptionLabel.text = forecast.weatherDescription
                self?.temperatureLabel.text = String(
                    format: "%.1f ºC",
                    forecast.temperature
                )
                self?.weatherIconImageView.kf.setImage(with: forecast.weatherIcon)
            }
        )
        .disposed(by: disposeBag)
                
        backButton
            .rx
            .controlEvent(.touchUpInside)
            .bind(to: backButtonTapped)
            .disposed(by: disposeBag)
    }
    
    private func configureTableView() {
        weatherDetailsTableView.register(
            FutureWeatherForecastViewCell.self,
            forCellReuseIdentifier: FutureWeatherForecastViewCell.cellReuseIdentifier
        )
        weatherDetailsTableView.register(
            WeatherForecastDetailViewCell.self,
            forCellReuseIdentifier: WeatherForecastDetailViewCell.cellReuseIdentifier
        )
        
        let dataSource = RxTableViewSectionedReloadDataSource<WeatherForecastSection>(
            configureCell: { dataSource, tableView, indexPath, item in
            
            switch item {
            case .futureWeatherForecast(let futureWeatherForecast):
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: FutureWeatherForecastViewCell.cellReuseIdentifier
                ) as! FutureWeatherForecastViewCell
                
                cell.setUp(withModel: futureWeatherForecast)
                return cell
            case .weatherForecastDetail(let weatherForecastDetail):
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: WeatherForecastDetailViewCell.cellReuseIdentifier
                ) as! WeatherForecastDetailViewCell
                cell.setUp(withModel: weatherForecastDetail)
                return cell
            }
        })
        
        viewModel.sections
            .bind(to: weatherDetailsTableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
}
