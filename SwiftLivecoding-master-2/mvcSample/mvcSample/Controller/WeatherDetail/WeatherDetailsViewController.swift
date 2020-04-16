//
//  WeatherDetailsViewController.swift
//  mvcSample
//
//  Created by Leszek Barszcz on 02/04/2020.
//  Copyright © 2020 lpb. All rights reserved.
//

import UIKit

final class WeatherDetailsViewController: UIViewController {
    @IBOutlet private weak var timeDateLabel: UILabel!
    @IBOutlet private weak var cityLabel: UILabel!
    @IBOutlet private weak var recentTemperatureLabel: UILabel!
    @IBOutlet private weak var weatherDescriptionlabel: UILabel!
    @IBOutlet weak var weeklyWeatherCollectionView: UICollectionView!
    
    private let weeklyDataSource = WeeklyWeatherCollectionDataSource()
    
    var selectedCityName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        fetchCurrentWeather()
        fetchForecast()
    }
    
    private func setupView() {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm MMMM d"
        timeDateLabel.text = dateFormatter.string(from: date)
        
        weeklyWeatherCollectionView.dataSource = weeklyDataSource
    }
    
    private func fetchCurrentWeather() {
        guard let selectedCityName = selectedCityName else { return }
        WeatherRepository.get5DaysForecast(for: selectedCityName) { [weak self] (weather, error) in
            guard let weather = weather else { return }
            
            self?.cityLabel.text = selectedCityName
            self?.recentTemperatureLabel.text = String(format: "%.0f°", (weather.list.first?.main.temp)!)
            self?.weatherDescriptionlabel.text = weather.list.first?.weather.first?.weatherDescription
        }
    }
    
    func daysBetween(start: Date, end: Date) -> Int {
           return Calendar.current.dateComponents([.day], from: start, to: end).day!
       }
    
    private func fetchForecast() {
        guard let selectedCityName = selectedCityName else {
            return
        }
        
        WeatherRepository.get5DaysForecast(for: selectedCityName) { [weak self] (forecast, error) in
            guard let forecast = forecast else { return }


            var daysAdded: [Int] = []
            let dailyForecast = forecast.list.filter { (item) -> Bool in
                
                let date = Date(timeIntervalSince1970: TimeInterval(item.dt))
                let today = Date()
                let modelDateComponents = Calendar.current.dateComponents([.day, .hour], from: date)
                let todayComponents = Calendar.current.dateComponents([.day, .hour] , from: today)
                let days = self!.daysBetween(start: today, end: date)
                print(modelDateComponents.day!)
                if !daysAdded.contains(modelDateComponents.day!) && days < 6 {
                    if abs(todayComponents.hour! - modelDateComponents.hour!) < 3 {
                        daysAdded.append(modelDateComponents.day!)
                        return true
                    }
                }
                
                return false
                
            
            }
            self?.weeklyDataSource.days = dailyForecast
            self?.weeklyWeatherCollectionView.reloadData()
        }
    }
}

/*
 Do podziałania samemu dwie rzeczy:
 przepisać fragment WeatherDetailsViewController żeby korzystać tylko z endpointu pobierającego 5-dniową prognozę,
 poprawić mechanizm filtrowania prognozy na 5 dni, żeby korzystał z DateComponents (przykładowe użycie w DailyWeatherCollectionViewCell)
 Może się przydać: https://medium.com/yay-its-erica/xcode-debugging-with-breakpoints-for-beginners-5b0d0a39d711
 */
