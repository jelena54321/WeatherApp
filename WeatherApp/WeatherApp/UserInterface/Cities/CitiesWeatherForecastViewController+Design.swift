//
//  CitiesWeatherForecastViewController+Design.swift
//  WeatherApp
//

import PureLayout

extension CitiesWeatherForecastViewController {
    
    func buildViews() {
        view = UIView(frame: UIScreen.main.bounds)
        view.backgroundColor = .white
        
        searchButton = UIButton()
        view.addSubview(searchButton)
        searchButton.setImage(UIImage(named: "searchIcon.png"), for: .normal)
        searchButton.autoPinEdge(.trailing, to: .trailing, of: view, withOffset: -20.0)
        searchButton.autoSetDimension(.width, toSize: 20.0)
        searchButton.autoSetDimension(.height, toSize: 20.0)
        
        searchTextField = UITextField()
        view.addSubview(searchTextField)
        searchTextField.font = UIFont.defaultFont()
        searchTextField.placeholder = "Search city..."
        searchTextField.autoPinEdge(.top, to: .top, of: view, withOffset: 70.0)
        searchTextField.autoPinEdge(.leading, to: .leading, of: view, withOffset: 20.0)
        searchTextField.autoPinEdge(.trailing, to: .leading, of: searchButton, withOffset: -20.0)
        searchTextField.autoSetDimension(.height, toSize: 40.0)
        
        searchButton.autoAlignAxis(.horizontal, toSameAxisOf: searchTextField)
        
        citiesTableView = UITableView()
        citiesTableView.separatorStyle = .none
        citiesTableView.showsVerticalScrollIndicator = false
        view.addSubview(citiesTableView)
        citiesTableView.autoPinEdge(.leading, to: .leading, of: view)
        citiesTableView.autoPinEdge(.trailing, to: .trailing, of: view)
        citiesTableView.autoPinEdge(.bottom, to: .bottom, of: view)
        citiesTableView.autoPinEdge(.top, to: .bottom, of: searchTextField, withOffset: 30.0)
    }
    
    func configureLayoutDependentViews() {
        searchTextField.layer.addSublayer({
            let border = CALayer()
            border.frame = CGRect(
                x: 0,
                y: searchTextField.bounds.height - 1,
                width: searchTextField.bounds.width,
                height: 1
            )
            border.backgroundColor = UIColor.darkGray.cgColor
            return border
        }())
    }
    
}

