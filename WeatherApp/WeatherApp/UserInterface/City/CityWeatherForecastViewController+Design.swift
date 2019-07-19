//
//  CityWeatherForecastViewController+Design.swift
//  WeatherApp
//

import PureLayout

extension CityWeatherForecastViewController {
    
    func buildViews() {
        view = UIView(frame: UIScreen.main.bounds)
        view.backgroundColor = .white
        
        backButton = BackButton()
        view.addSubview(backButton)
        backButton.autoPinEdge(.leading, to: .leading, of: view, withOffset: 20.0)
        backButton.autoPinEdge(.top, to: .top, of: view, withOffset: 50.0)
        backButton.autoSetDimension(.width, toSize: 70.0)
        
        cityLabel = UILabel()
        view.addSubview(cityLabel)
        cityLabel.font = UIFont.cityTitleRegular()
        cityLabel.textAlignment = .center
        cityLabel.autoPinEdge(.top, to: .bottom, of: backButton, withOffset: 30.0)
        cityLabel.autoAlignAxis(.vertical, toSameAxisOf: view)
        
        weatherDescriptionLabel = UILabel()
        view.addSubview(weatherDescriptionLabel)
        weatherDescriptionLabel.font = .defaultFont()
        weatherDescriptionLabel.textAlignment = .center
        weatherDescriptionLabel.autoPinEdge(.top, to: .bottom, of: cityLabel, withOffset: 5.0)
        weatherDescriptionLabel.autoSetDimension(.height, toSize: 40.0)
        weatherDescriptionLabel.autoAlignAxis(.vertical, toSameAxisOf: view)
        
        weatherIconImageView = UIImageView()
        weatherIconImageView.contentMode = UIView.ContentMode.scaleAspectFill
        view.addSubview(weatherIconImageView)
        weatherIconImageView.autoPinEdge(.top, to: .bottom, of: weatherDescriptionLabel, withOffset: 10.0)
        weatherIconImageView.autoAlignAxis(.vertical, toSameAxisOf: view)
        
        temperatureLabel = UILabel()
        view.addSubview(temperatureLabel)
        temperatureLabel.font = .tempRegular()
        temperatureLabel.textAlignment = .center
        temperatureLabel.autoPinEdge(.top, to: .bottom, of: weatherIconImageView, withOffset: 10.0)
        temperatureLabel.autoAlignAxis(.vertical, toSameAxisOf: view)
        
        weatherDetailsTableView = UITableView()
        view.addSubview(weatherDetailsTableView)
        weatherDetailsTableView.showsVerticalScrollIndicator = false
        weatherDetailsTableView.separatorStyle = .none
        weatherDetailsTableView.autoPinEdge(.leading, to: .leading, of: view)
        weatherDetailsTableView.autoPinEdge(.trailing, to: .trailing, of: view)
        weatherDetailsTableView.autoPinEdge(.bottom, to: .bottom, of: view)
        weatherDetailsTableView.autoPinEdge(.top, to: .bottom, of: temperatureLabel, withOffset: 40.0)
    }
}
