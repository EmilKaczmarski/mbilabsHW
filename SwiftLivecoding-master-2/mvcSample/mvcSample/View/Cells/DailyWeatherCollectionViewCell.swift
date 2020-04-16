//
//  DailyWeatherCollectionViewCell.swift
//  mvcSample
//
//  Created by Leszek Barszcz on 07/04/2020.
//  Copyright © 2020 lpb. All rights reserved.
//

import UIKit

class DailyWeatherCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var todayLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var weekdayLabel: UILabel!
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!

    var model: List! {
        didSet {
            let date = Date(timeIntervalSince1970: TimeInterval(model.dt))
            let today = Date()

            let modelDateComponents = Calendar.current.dateComponents([.weekOfYear, .day, .weekday], from: date)
            let todayComponents = Calendar.current.dateComponents([.weekOfYear, .day, .weekday], from: today)

            let modelIsForToday = modelDateComponents.weekOfYear == todayComponents.weekOfYear && modelDateComponents.day == todayComponents.day

            todayLabel.isHidden = !modelIsForToday
            weekdayLabel.text = "\(modelDateComponents.weekday!)"
            temperatureLabel.text = String(format: "%.0f°", model.main.temp)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

        containerView.layer.cornerRadius = 16
    }
}
