//
//  strucFile.swift
//  weather app
//
//  Created by C. Jordan Ball III on 7/16/21.
//

import Foundation

struct WeatherData: Decodable {
    let name: String;
    let main: Main;
    let weather: Array<Weather>;
}

struct Weather: Codable {
    let description: String;
    let id: Int;
}

struct Main: Codable {
    let temp: Double;
}
