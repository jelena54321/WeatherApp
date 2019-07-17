//
//  CitiesWeatherForecastViewCell+Design.swift
//  WeatherApp
//

import PureLayout

extension CitiesWeatherForecastViewCell {
    
    func buildViews() {
        viewsContainer = UIView()
        viewsContainer.backgroundColor = .white
        viewsContainer.layer.cornerRadius = 10.0
        viewsContainer.layer.masksToBounds = false
        viewsContainer.layer.shadowColor = UIColor.black.cgColor
        viewsContainer.layer.shadowOffset = CGSize(width: 5, height: 5)
        viewsContainer.layer.shadowRadius = 5
        viewsContainer.layer.shadowOpacity = 0.3
        addSubview(viewsContainer)
        viewsContainer.autoPinEdge(.top, to: .top, of: self, withOffset: 10.0)
        viewsContainer.autoPinEdge(.bottom, to: .bottom, of: self, withOffset: -10.0)
        viewsContainer.autoPinEdge(.leading, to: .leading, of: self, withOffset: 15.0)
        viewsContainer.autoPinEdge(.trailing, to: .trailing, of: self, withOffset: -15.0)
        viewsContainer.autoSetDimension(.height, toSize: 100.0)
        
        weatherIcon = UIImageView()
        viewsContainer.addSubview(weatherIcon)
        weatherIcon.autoAlignAxis(.horizontal, toSameAxisOf: viewsContainer)
        weatherIcon.autoPinEdge(.leading, to: .leading, of: viewsContainer, withOffset: 20.0)
        weatherIcon.autoSetDimension(.width, toSize: 80.0)
        weatherIcon.autoSetDimension(.height, toSize: 80.0)
        
        cityLabel = UILabel()
        cityLabel.font = UIFont.cityTitleLight()
        viewsContainer.addSubview(cityLabel)
        cityLabel.autoPinEdge(.leading, to: .trailing, of: weatherIcon, withOffset: 20.0)
        cityLabel.autoAlignAxis(.horizontal, toSameAxisOf: viewsContainer)
        
        maxTemperatureLabel = UILabel()
        viewsContainer.addSubview(maxTemperatureLabel)
        
        minTemperatureLabel = UILabel()
        minTemperatureLabel.font = UIFont.minTempRegular()
        minTemperatureLabel.textAlignment = .right
        viewsContainer.addSubview(minTemperatureLabel)
        minTemperatureLabel.autoSetDimension(.width, toSize: 50.0)
        minTemperatureLabel.autoPinEdge(.trailing, to: .trailing, of: viewsContainer, withOffset: -20.0)
        minTemperatureLabel.autoPinEdge(.bottom, to: .bottom, of: maxTemperatureLabel)
        
        maxTemperatureLabel.font = UIFont.maxTempRegular()
        maxTemperatureLabel.textAlignment = .right
        maxTemperatureLabel.autoPinEdge(.trailing, to: .leading, of: minTemperatureLabel, withOffset: -10.0)
        maxTemperatureLabel.autoAlignAxis(.horizontal, toSameAxisOf: viewsContainer)
    }
}
