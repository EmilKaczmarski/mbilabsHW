//
//  ViewController.swift
//  mvcSample
//
//  Created by Leszek Barszcz on 05/03/2020.
//  Copyright © 2020 lpb. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var bottomBar: UIView!
    override func loadView() {
        super.loadView()
        
        /*
         Here view is being initiated from storyboards, xibs
         */
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view. Usually we set data here, no final sizes are set here
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor(red: 85.0/255.0, green: 157.0/255.0, blue: 1.0, alpha: 1.0).cgColor, UIColor.white.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        gradientLayer.frame = view.bounds
        view.layer.insertSublayer(gradientLayer, at: 0)
        
        let mask = CAShapeLayer()
        
        mask.frame = bottomBar.bounds
        
        let path = UIBezierPath(rect: bottomBar.bounds)
        
        let amplitude: CGFloat = 0.1
        
        let width = bottomBar.frame.width
        let height = bottomBar.frame.height
        let origin = CGPoint(x: 0, y: height / 2)
        path.move(to: origin)
        for angle in stride(from: 0, through: 360.0, by: 5.0) {
            let x = origin.x + CGFloat(angle/360.0) * width
            let y = origin.y - CGFloat(sin(angle/180.0 * Double.pi)) * height * amplitude
            path.addLine(to: CGPoint(x: x, y: y))
        }
        path.addLine(to: CGPoint(x: bottomBar.frame.width, y: 0))
        path.addLine(to: CGPoint.zero)
        
        path.close()
        
        mask.path = path.cgPath
        
        bottomBar.layer.mask = mask
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //        UserDefaults.standard.set("Gdansk", forKey: "selectedCity")
        
        if let cityListData = UserDefaults.standard.data(forKey: "CityList") {
            
            let decoder = JSONDecoder()
            do {
                let cityList = try decoder.decode(CityList.self, from: cityListData)
                
                DispatchQueue.global().async {
                    var weatherList = [CityWeather]()
                    let group = DispatchGroup()
                    
                    cityList.cities.forEach{ city in
                        group.enter()
                        WeatherRepository.getCurrentWeather(city.title) { weather, error in
                            group.leave()
                            if let weather = weather {
                                let cityWeather = CityWeather(cityName: city.title, temperature: weather.main.temp)
                                weatherList.append(cityWeather)
                            }
                        }
                    }
                    
                    group.wait()
                    DispatchQueue.main.async {
                        self.showCityList(weatherList)
                    }
                }
            } catch {
                
            }
        }
    }
    
    func showCityList(_ weathers: [CityWeather]) {
        
        let cityListVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "LocationListViewController") as! LocationListViewController
        cityListVC.cityList = weathers
        view.insertSubview(cityListVC.view, belowSubview: bottomBar)
        
        cityListVC.view.translatesAutoresizingMaskIntoConstraints = false
        
//        cityListVC.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
//        cityListVC.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
//
//        cityListVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
//        cityListVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        addChild(cityListVC)
        
        cityListVC.view.snp.makeConstraints { maker in
            maker.top.bottom.equalTo(view.safeAreaLayoutGuide)
            maker.leading.trailing.equalToSuperview()
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Here you can start some animations which are required to be seen by users from beginning
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Here you can start saving data when leaving screen
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        // View is no longer visible, eg. stop animating things
    }
    
    @IBAction func unitTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
    }
    
    @IBAction func plusTapped(_ sender: UIButton) {
        //        1. Navigate to details page using segue
        //        navigateWithSegue()
        //        2. Navigate to details page using navigation controller
        //        navigateWithNavigationController()
        //        3. Navigate to details page using modal presentation
        //        navigateWithModalPresent()
        
        navigationController?.pushViewController(SearchViewController(), animated: true)
    }
    
    //    Called when we return to this view controller
    @IBAction func unwindToDashboard(_ unwindSegue: UIStoryboardSegue) {
        
        print("we're back")
    }
    
    //    Called before each segue is actually performed
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier! {
        case "toDeatails":
            print("going to details")
        case "toSettings":
            print("going to Setting")
        default:
            fatalError()
        }
        print(String(describing: sender))
        print(String(describing: segue.identifier))
    }
    
    private func navigateWithSegue() {
        //        We pass in segue identifier which was set in storyboard
        performSegue(withIdentifier: "toDeatails", sender: nil)
    }
    
    private func navigateWithNavigationController() {
        //        We instantiate the storyboard by passing it's file name to constructor.
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        //        By having storyboard instance we can instantiate destination view controller
        let detailsViewController = storyboard.instantiateViewController(identifier: "DetailsViewController")
        //        Pushing new view controller onto navigation stack
        self.navigationController?.pushViewController(detailsViewController, animated: true)
    }
    
    private func navigateWithModalPresent() {
        //        We instantiate the storyboard by passing it's file name to constructor.
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        //        By having storyboard instance we can instantiate destination view controller
        let detailsViewController = storyboard.instantiateViewController(identifier: "DetailsViewController")
        //        We present modaly detailsViewController from current view controller
        self.present(detailsViewController, animated: true, completion: nil)
    }
    
}

