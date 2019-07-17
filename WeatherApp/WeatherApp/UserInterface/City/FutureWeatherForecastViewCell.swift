//
//  FutureWeatherForecastViewCell.swift
//  WeatherApp
//

import UIKit
import Kingfisher

class FutureWeatherForecastViewCell: UITableViewCell {
    
    static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        dateFormatter.dateFormat = WeatherConstants.dayFormatString
        return dateFormatter
    }()
    
    static let temperatureStringFormat = "%.0f"
    static let cellReuseIdentifier = "futureWeatherForecastCellID"
    
    var dayLabel: UILabel!
    var weatherIcon: UIImageView!
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
    
    func setUp(withModel model: FutureWeatherForecastModel) {
        dayLabel.text = FutureWeatherForecastViewCell.dateFormatter.string(from: model.timestamp)
        if let imageIconUrl = model.weatherIcon {
            weatherIcon.kf.setImage(with: imageIconUrl)
        }
        maxTemperatureLabel.text = String(
            format: FutureWeatherForecastViewCell.temperatureStringFormat,
            model.maxTemperature
        )
        minTemperatureLabel.text = String(
            format: FutureWeatherForecastViewCell.temperatureStringFormat,
            model.minTemperature
        )
    }

}
