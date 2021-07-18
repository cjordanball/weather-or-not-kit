//
//  WeatherModel.swift
//  weather app
//
//  Created by C. Jordan Ball III on 7/16/21.
//

import Foundation

struct WeatherModel {
    let conditionId: Int;
    let cityName: String;
    let temp: Double;
    
    var conditionName: String {
        return getConditionName(conditionId) ?? "NA";
    }
    
    var tempString: String {
        return String(format: "%.1f", temp);
    }
    
    func getConditionName(_ weatherCode: Int) -> String? {
        switch (weatherCode) {
            case 200...299:
                return "cloud.bolt.rain";
            case 300...399:
                return "cloud.drizzle";
            case 500...599:
                return "cloud.rain";
            case 600...699:
                return "cloud.snow";
            case 700...799:
                return "smoke";
        case 800...:
                return "sun.max";
            default:
                return nil;
        }
    }
}
