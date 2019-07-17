//
//  WeatherForecastDetailViewCell.swift
//  WeatherApp
//

import UIKit

class WeatherForecastDetailViewCell: UITableViewCell {
    
    static let cellReuseIdentifier = "weatherForecastDetailCellID"
    
    var detailLabel: UILabel!
    var detailValueLabel: UILabel!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        buildViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        buildViews()
    }
    
    func setUp(withModel model: WeatherForecastDetailModel) {
        detailLabel.text = model.weatherDetail
        detailValueLabel.text = model.weatherDetailValue
    }
    
}
