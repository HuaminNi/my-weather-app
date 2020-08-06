//
//  WeatherData.swift
//  Clima
//
//  Created by huaminni on 8/4/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation

//为了parse json，需要告知其要呈现的结构：这里同时需要用到decodable这个protocol，证明其是可以被decode的
struct WeatherData : Decodable {
    var name : String
    var main: Main
    var weather: [Weather]
}

struct Main : Decodable {
    //要确保以下所有变量名都符合取到的json data
    var temp:Double
}

struct Weather : Decodable {
    var id: Int
}
