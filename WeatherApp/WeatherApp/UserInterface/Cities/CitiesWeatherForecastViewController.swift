//
//  CitiesWeatherForecastViewController.swift
//  WeatherApp
//

import UIKit
import RxSwift

class CitiesWeatherForecastViewController: UIViewController {
    
    var searchTextField: UITextField!
    var searchButton: UIButton!
    var citiesTableView: UITableView!
    
    private var viewModel: CitiesWeatherForecastViewModel!
    private var refreshControl: UIRefreshControl!
    
    let citySelected = PublishSubject<String>()
    let searchButtonTapped = PublishSubject<Void>()
    let disposeBag = DisposeBag()
    
    convenience init(viewModel: CitiesWeatherForecastViewModel) {
        self.init()
        self.viewModel = viewModel
    }
    
    override func loadView() {
        buildViews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpSearchHandling()
        setUpTableView()
        setUpCellConfiguration()
        setUpRefreshControl()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureLayoutDependentViews()
    }
    
    private func setUpSearchHandling() {
        searchButton
            .rx
            .controlEvent(.touchUpInside)
            .subscribe(onNext: { [weak self] _ in
                guard
                    let self = self,
                    let city = self.searchTextField.text
                    else { return }
                
                self.citySelected.onNext(city)
            })
            .disposed(by: disposeBag)
    }
    
    private func setUpTableView() {
        citiesTableView.register(
            CitiesWeatherForecastViewCell.self,
            forCellReuseIdentifier: CitiesWeatherForecastViewCell.cellIdentifier
        )
        
        citiesTableView
            .rx
            .modelSelected(DailyWeatherForecastModel.self)
            .subscribe(onNext: { [weak self] dailyWeatherForecast in
                self?.citySelected.onNext(dailyWeatherForecast.city)
                
                if let selectedIndexPath = self?.citiesTableView.indexPathForSelectedRow {
                    self?.citiesTableView.deselectRow(at: selectedIndexPath, animated: true)
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func setUpCellConfiguration() {
        viewModel.citiesWeatherForecast
            .bind(to: citiesTableView
                .rx
                .items(
                    cellIdentifier: CitiesWeatherForecastViewCell.cellIdentifier,
                    cellType: CitiesWeatherForecastViewCell.self)) {
                        row, cityWeatherForecast, cell in
                        cell.setUp(withModel: cityWeatherForecast)
            }
            .disposed(by: disposeBag)
    }
    
    private func setUpRefreshControl() {
        refreshControl = UIRefreshControl()
        citiesTableView.refreshControl = refreshControl
        
        refreshControl
            .rx
            .controlEvent(.valueChanged)
            .bind(to: viewModel.refreshData)
            .disposed(by: disposeBag)
        
        viewModel.fetchingIndicator
            .bind(to: refreshControl.rx.isRefreshing)
            .disposed(by: disposeBag)
    }
}
