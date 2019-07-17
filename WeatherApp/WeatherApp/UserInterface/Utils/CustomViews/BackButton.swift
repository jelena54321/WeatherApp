//
//  BackButton.swift
//  WeatherApp
//

import UIKit

class BackButton: UIButton {
    
    let arrowImageIcon = UIImageView()
    let backLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpUI()
    }
    
    private func setUpUI() {
        arrowImageIcon.image = UIImage(
            cgImage: UIImage(named: "arrow.png")!.cgImage!,
            scale: 1.0,
            orientation: UIImage.Orientation.upMirrored
        )
        addSubview(arrowImageIcon)
        arrowImageIcon.autoPinEdge(.leading, to: .leading, of: self)
        arrowImageIcon.autoPinEdge(.top, to: .top, of: self)
        arrowImageIcon.autoPinEdge(.bottom, to: .bottom, of: self)
        arrowImageIcon.autoSetDimension(.width, toSize: 20.0)
        arrowImageIcon.autoSetDimension(.height, toSize: 20.0)
        
        backLabel.text = "back"
        backLabel.font = UIFont.backButtonLight()
        addSubview(backLabel)
        backLabel.autoPinEdge(.leading, to: .trailing, of: arrowImageIcon)
        backLabel.autoPinEdge(.top, to: .top, of: self)
        backLabel.autoPinEdge(.bottom, to: .bottom, of: self)
        backLabel.autoPinEdge(.trailing, to: .trailing, of: self)
    }
}
