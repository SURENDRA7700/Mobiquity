//
//  CustomCollViewCell.swift
//  coll
//
//  Created by surendra kumar k on 24/03/19.
//  Copyright © 2019 surendra. All rights reserved.
//

import UIKit
import MapKit

class CustomCollViewCell: UICollectionViewCell {

    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var middleLabel: UILabel!
    @IBOutlet weak var endLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    func configureLayout(weatherData : WeatherModel?,index : Int) {
        
        switch index {
        case 0: do{
            self.headerLabel.text = "Weather Info"
            
            self.topLabel.text = weatherData?.weather.first?.main
            self.middleLabel.text = weatherData?.weather.first?.weatherDescription
            self.endLabel.text = weatherData?.weather.first?.icon
        }
        break
        case 1:
            do{
                self.headerLabel.text = "Temparature & Humidity Info"
                let minTemp = "min Temp : \(weatherData?.main.tempMin ?? 0)"
                let tempMax = "max Temp : \(weatherData?.main.tempMax ?? 0)"
                let humidity = "humidity : \(weatherData?.main.humidity ?? 0)"

                self.topLabel.text = minTemp
                self.middleLabel.text = tempMax
                self.endLabel.text = humidity

            }
            break
        case 2: do{
            self.headerLabel.text = "Wind Info"
            let speed = "speed : \(weatherData?.wind.speed ?? 0)"
            let deg = "deg : \(weatherData?.wind.deg ?? 0)"
            let gust = "gust : \(weatherData?.wind.deg ?? 0)"
            self.topLabel.text = speed
            self.middleLabel.text = deg
            self.endLabel.text = gust

        }
        break
        default: break
            
        }
    }

}
