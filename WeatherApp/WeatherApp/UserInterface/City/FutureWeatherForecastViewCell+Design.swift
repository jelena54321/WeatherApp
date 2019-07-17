//
//  FutureWeatherForecastViewCell+Design.swift
//  WeatherApp
//

import UIKit

extension FutureWeatherForecastViewCell {
    
    func buildViews() {
        dayLabel = UILabel()
        dayLabel.font = UIFont.defaultFont()
        addSubview(dayLabel)
        dayLabel.autoPinEdge(.leading, to: .leading, of: self, withOffset: 20.0)
        dayLabel.autoPinEdge(.top, to: .top, of: self)
        dayLabel.autoPinEdge(.bottom, to: .bottom, of: self)
        dayLabel.autoSetDimension(.width, toSize: 150.0)
        
        weatherIcon = UIImageView()
        addSubview(weatherIcon)
        weatherIcon.autoSetDimension(.height, toSize: 30.0)
        weatherIcon.autoSetDimension(.width, toSize: 30.0)
        weatherIcon.autoAlignAxis(.vertical, toSameAxisOf: self)
        weatherIcon.autoAlignAxis(.horizontal, toSameAxisOf: self)
        
        minTemperatureLabel = UILabel()
        minTemperatureLabel.font = UIFont.defaultBoldFont()
        minTemperatureLabel.textColor = .lightGray
        addSubview(minTemperatureLabel)
        minTemperatureLabel.autoPinEdge(.trailing, to: .trailing, of: self, withOffset: -20.0)
        minTemperatureLabel.autoPinEdge(.top, to: .top, of: self)
        minTemperatureLabel.autoPinEdge(.bottom, to: .bottom, of: self)
        minTemperatureLabel.autoSetDimension(.width, toSize: 40.0)
        
        maxTemperatureLabel = UILabel()
        maxTemperatureLabel.font = UIFont.defaultBoldFont()
        addSubview(maxTemperatureLabel)
        maxTemperatureLabel.autoPinEdge(.trailing, to: .leading, of: minTemperatureLabel, withOffset: -20.0)
        maxTemperatureLabel.autoPinEdge(.top, to: .top, of: self)
        maxTemperatureLabel.autoPinEdge(.bottom, to: .bottom, of: self)
        maxTemperatureLabel.autoSetDimension(.width, toSize: 40.0)
    }
}
