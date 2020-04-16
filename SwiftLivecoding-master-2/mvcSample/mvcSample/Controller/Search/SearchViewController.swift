//
//  SearchViewController.swift
//  mvcSample
//
//  Created by Leszek Barszcz on 17/03/2020.
//  Copyright © 2020 lpb. All rights reserved.
//

import UIKit
import CoreLocation

final class SearchViewController: UIViewController {
    private let locationCellIdentifier = "locationCell"

    private var historyItems: [SearchItem] = []
    private var allItems: [SearchItem] = []
    private var visibleItems = [SearchItem]()

    private var tapGestureRecogniser: UITapGestureRecognizer!
    private lazy var locationManager: CLLocationManager = CLLocationManager()

    weak var tableView: UITableView!
    var searchBar: UISearchBar!

    override func loadView() {
        super.loadView()

        let tableView = UITableView()
        self.searchBar = UISearchBar()
        self.tapGestureRecogniser = UITapGestureRecognizer()
        self.view.addSubview(tableView)
        self.view.addSubview(searchBar)
        self.tableView = tableView
    }
    
    @objc
    func hideKeyboard() {
        view.endEditing(true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        
        tapGestureRecogniser.addTarget(self, action: #selector(hideKeyboard))
        searchBar.delegate = self
        tableView.backgroundColor = .clear
        tableView.rowHeight = 62
        tableView.separatorStyle = .none
        tableView.keyboardDismissMode = .interactive

        tableView.translatesAutoresizingMaskIntoConstraints = false
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        
        searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
         tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor).isActive = true
        
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
       
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true

        tableView.register(LocationTableViewCell.self, forCellReuseIdentifier: locationCellIdentifier)

        tableView.dataSource = self
        tableView.delegate = self

        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor(red: 85.0/255.0, green: 157.0/255.0, blue: 1.0, alpha: 1.0).cgColor,
            UIColor(red: 55.0/255.0, green: 140.0/255.0, blue: 1.0, alpha: 1.0).cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        gradientLayer.frame = view.bounds
        view.layer.insertSublayer(gradientLayer, at: 0)

        CityRepository.getAllCities { [weak self] cities in
            self?.allItems = cities.map { city in
                return SearchItem(city: city.name, country: city.country, alternativeText: "", type: .plain)
            }
            self?.visibleItems = self?.allItems ?? []
            self?.tableView.reloadData()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
         
        let decoder = JSONDecoder()
        
        let citiList = historyItems.map{ CityObject(title: $0.city, dateAdded: Date()) }
        let encoder = JSONEncoder()
        do {
            var listObject: CityList

            if let previousListData = UserDefaults.standard.data(forKey: "CityList") {
                let previousCityList = try decoder.decode(CityList.self, from: previousListData)
                listObject = CityList(cities: previousCityList.cities + citiList)
            } else {
                listObject = CityList(cities: citiList)
            }
            
            let data = try encoder.encode(listObject)
            UserDefaults.standard.set(data, forKey: "CityList")
        } catch {
            print(error)
        }
        
    }
}

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return visibleItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: locationCellIdentifier, for: indexPath) as? LocationTableViewCell else { return UITableViewCell() }

        cell.model = visibleItems[indexPath.row]
        return cell
    }
}

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var tappedItem = visibleItems[indexPath.row]
        
        if !historyItems.contains(where: { item -> Bool in
            return item == tappedItem
        }) {
            tappedItem.type = .history
            historyItems.append(tappedItem)
        }

        openDetails(for: tappedItem)
    }

    private func openDetails(for selection: SearchItem) {
        let detailsVC = UIStoryboard(name: "Main",
                                     bundle: nil)
            .instantiateViewController(identifier: "WeatherDetailsViewController") as! WeatherDetailsViewController

        detailsVC.selectedCityName = selection.city

        navigationController?.pushViewController(detailsVC, animated: true)
    }
}

struct CityList: Codable {
    let cities: [CityObject]
}

struct CityObject: Codable  {
    let title: String
    let dateAdded: Date
}

extension SearchViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            visibleItems = historyItems
            hideKeyboard()
        } else {
            visibleItems = allItems.filter({ $0.city.contains(searchText) })
        }
        tableView.reloadData()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        visibleItems = historyItems
        tableView.reloadData()
    }
}

extension SearchViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//
//        if status == .authorizedWhenInUse {
//            historyItems.insert(SearchItem(city: "", country: "", alternativeText: "Your current location", type: .currentLocation), at: 0)
//            tableView.reloadData()
//        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(locations)
//        if items.count > 0,
//            let location = locations.first {
//            let newItem = SearchItem(city: "",
//                                     country: "",
//                                     alternativeText: "\(location.coordinate.latitude) \(location.coordinate.longitude)",
//                type: .currentLocation)
//
//            items.remove(at: 0)
//            items.insert(newItem, at: 0)
//            tableView.reloadData()
//        }
    }
}
