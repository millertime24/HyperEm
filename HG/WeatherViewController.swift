//
//  WeatherViewController.swift
//  HG
//
//  Created by Andrew on 8/15/17.
//  Copyright © 2017 Andrew. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController, UISearchBarDelegate {
    
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBAction func cancel(_ sender: Any) {
          dismiss(animated: true, completion: nil)
        
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text {
            WeatherController.weatherBySearchCity(searchText) { (result) in
                guard let weatherResult = result else { return }
                
                DispatchQueue.main.async { () in
                    self.cityNameLabel.text = weatherResult.cityName
                    if let temperatureC = weatherResult.temperatureC {
                        self.temperatureLabel.text = String(temperatureC) + " °C"
                    } else {
                        self.temperatureLabel.text = "No temperature available"
                    }
                    self.mainLabel.text = weatherResult.main
                    self.descriptionLabel.text = weatherResult.description
                }
                
                WeatherController.weatherIconForIconCode(weatherResult.iconString, completion: { (image) -> Void in
                    DispatchQueue.main.async(execute: { () -> Void in
                        self.iconImageView.image = image
                    })
                })
            }
        }
        
        searchBar.resignFirstResponder()
    }
}

