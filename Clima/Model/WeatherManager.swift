//
//  Test.swift
//  Clima
//
//  Created by huaminni on 8/3/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager:WeatherManager, weather: WeatherModel)
    func didFailWithError(error:Error)
}

struct WeatherManager {
    var weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=0031705c90848ed0c731a2c09a0f1e51&units=metric"
    
    var delegate: WeatherManagerDelegate? // sets our delegate as a optional WeatherManagerDelegate,so if some class or some struct has set themselves as the delegate, then we would be able to call upon the delegate and tell it to update the weather
    
    func fetchWeather(cityName:String){
        let urlString = "\(weatherURL)&q=\(cityName)"
        print(urlString)
        performRequest(urlString: urlString)
    }
    
    func fetchWeather(latitude: CLLocationDegrees, longitude:CLLocationDegrees){
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(urlString: urlString)
    }
    
    func performRequest(urlString: String){
        //how to do networking?
        //1, create a URL
        if let url = URL(string: urlString){
            //2,create a URLSession
            let session = URLSession(configuration: .default)
            //3, give session a task
            let task = session.dataTask(with: url, completionHandler: handle(data:response:error:))
            //4, start the task
            task.resume()
        }
    }
    
    func handle(data:Data?,response:URLResponse?, error:Error?){
        if error != nil {
            //print(error!)
            delegate?.didFailWithError(error:error!)
            return
        }
        
        if let safeData = data {
            //如果要打印，就用下面这两行：
            //let dataString = String(data: safeData, encoding: .utf8)
            //print(dataString)
            if let weather = parseJSON(safeData) {
                //如何把这个数据给到viewcontroller呢？
//                let weatherVC = WeatherViewController()
//                weatherVC.didUpdateWeather(weather: weather)
                delegate?.didUpdateWeather(self, weather:weather)
            }
        }
    }
    
    func parseJSON (_ weatherData:Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData) // decode这个方程返回weatherdata这个type
            let temp = decodedData.main.temp
            let id = decodedData.weather[0].id
            let name = decodedData.name
            
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
            print(weather.conditionName)
            print(weather.tempString)
            return weather
            
        } catch {
            //print(error)
            delegate?.didFailWithError(error:error)
            return nil
        }
        
    }
    
    
}
