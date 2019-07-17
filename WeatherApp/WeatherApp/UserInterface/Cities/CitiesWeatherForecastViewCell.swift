//
//  CitiesWeatherForecastViewCell.swift
//  WeatherApp
//

import UIKit
import Kingfisher

class CitiesWeatherForecastViewCell: UITableViewCell {
    
    static let cellIdentifier = "citiesCellID"
    private static let temperatureFormat = "%.1fº"
    
    var viewsContainer: UIView!
    var weatherIcon: UIImageView!
    var cityLabel: UILabel!
    var maxTemperatureLabel: UILabel!
    var minTemperatureLabel: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        buildViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        buildViews()
    }
    
    func setUp(withModel model: DailyWeatherForecastModel) {
        cityLabel.text = model.city
        maxTemperatureLabel.text = String(
            format: CitiesWeatherForecastViewCell.temperatureFormat,
            model.maxTemperature
        )
        minTemperatureLabel.text = String(
            format: CitiesWeatherForecastViewCell.temperatureFormat,
            model.minTemperature
        )
        
        if let imageIconUrl = model.weatherIcon {
            weatherIcon.kf.setImage(with: imageIconUrl)
        }
    }
}
