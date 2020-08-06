//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation  //comes with sth callled locationManager

class WeatherViewController: UIViewController {

    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()  // responsible for holding the gps location of phone
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization() // triger.will show up a pop up window for user's permittion
        locationManager.requestLocation()
        
        searchTextField.delegate = self
        // set the current class as the delegate
        weatherManager.delegate = self
        
        
    }
    
    @IBAction func locationPressed(_ sender: UIButton) {
        locationManager.requestLocation()
    }
}

//MARK: - UITextFieldDelegate


extension WeatherViewController:UITextFieldDelegate {
    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
        print(searchTextField.text!)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
             print(searchTextField.text!)
        return true
    } // 使用delegate模式，textfield通知view controller：“hey, pressed the return!”
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        }else {
            textField.placeholder = "Type something"
            return false
        }
    } // 这里可以直接用textField而不是searchTextField，因为这里的textField和button action里的sender一样，当有多个button或者textfield时，可以进行判断；因为这里只有一个textfield，所以不需要使用searchtextfield
    
    //注意，如果textfieldshouldendediting返回false，则不能trigger下一个方程：textFieldDidEndEditing
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let city = searchTextField.text {
            weatherManager.fetchWeather(cityName: city)
        }
        searchTextField.text = ""
    } // tells delegate that editting is stopped
}

//MARK: - WeatherManagerDelegate

extension WeatherViewController: WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager:WeatherManager,weather: WeatherModel) {
            DispatchQueue.main.async {
                self.temperatureLabel.text = weather.tempString
                self.conditionImageView.image = UIImage(systemName:weather.conditionName)
                self.cityLabel.text = weather.cityName
            }
        }

    
    func didFailWithError(error:Error) {
        print(error)
    }
}

extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        if let location = locations.last {
            locationManager.stopUpdatingLocation() //没有这个语句的话，倘若current pos没变就不会更新，不会call上述func
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fetchWeather(latitude: lat,longitude:lon)
        } // last of arrat in cllocation
        print(locations)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

