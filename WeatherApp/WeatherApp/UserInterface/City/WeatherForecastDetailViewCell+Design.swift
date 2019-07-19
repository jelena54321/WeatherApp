//
//  WeatherForecastDetailViewCell+Design.swift
//  WeatherApp
//

import UIKit

extension WeatherForecastDetailViewCell {
    
    func buildViews() {
        detailLabel = UILabel()
        detailLabel.font = .weatherDetailFont()
        addSubview(detailLabel)
        detailLabel.autoPinEdge(.leading, to: .leading, of: self, withOffset: 20.0)
        detailLabel.autoPinEdge(.top, to: .top, of: self)
        detailLabel.autoPinEdge(.bottom, to: .bottom, of: self)
        
        detailValueLabel = UILabel()
        detailValueLabel.font = .defaultBoldFont()
        addSubview(detailValueLabel)
        detailValueLabel.autoPinEdge(.trailing, to: .trailing, of: self, withOffset: -20.0)
        detailValueLabel.autoPinEdge(.top, to: .top, of: self, withOffset: 10.0)
        detailValueLabel.autoPinEdge(.bottom, to: .bottom, of: self, withOffset: -10.0)
    }
}
