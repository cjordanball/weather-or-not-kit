//
//  WeatherManager.swift
//  weather app
//
//  Created by C. Jordan Ball III on 7/16/21.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel);
    func didFailWithError(error: Error);
}

extension String {
    func trimTrailingSpaces(using charSet: CharacterSet = .whitespacesAndNewlines) -> String {
        guard let index = lastIndex(where: { !CharacterSet(charactersIn: String($0)).isSubset(of: charSet) }) else {
            return self
        }
        return String(self[...index]);
    }
}

struct WeatherManager {
    var weatherDelegate: WeatherManagerDelegate?;
    let constants = Constants();
    
    func fetchWeather(cityName: String) {
        let modCityName = cityName.trimTrailingSpaces();
        let baseURL = "\(constants.weatherURL)?appid=\(constants.appid)";
        let urlString = "\(baseURL)&units=\(constants.units)&q=\(modCityName)";
        let spaceReplacedString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        if let finalString = spaceReplacedString {
            performRequest(finalString);
        }
    }
    
    func fetchWeather(lat: CLLocationDegrees, lng: CLLocationDegrees) {
        let baseURL = "\(constants.weatherURL)?appid=\(constants.appid)";
        let urlString = "\(baseURL)&units=\(constants.units)&lat=\(lat)&lon=\(lng)";
        performRequest(urlString);
    }
    
    func performRequest(_ urlString: String) {
        // i) create url
        if let url = URL(string: urlString) {
            // ii) create urlSession
            let session = URLSession(configuration: .default);
            // iii) create task for urlSession
            let task = session.dataTask(with: url) { (data, response, err) in
                if (err != nil) {
                    self.weatherDelegate?.didFailWithError(error: err!);
                    return;
                }
                if let safeData = data {
                    if let weather = self.parseJSON(weatherData: safeData) {
                        self.weatherDelegate?.didUpdateWeather(self, weather: weather);
                    }
                }
            }
            // iv) run the task
            task.resume();
        }
    }
    
    func parseJSON(weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder();
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData);
            let code = decodedData.weather[0].id;
            let temp = decodedData.main.temp;
            let name = decodedData.name;
            
            let weather = WeatherModel(conditionId: code, cityName: name, temp: temp);
            return weather;
        } catch {
            self.weatherDelegate?.didFailWithError(error: error)
            return nil;
        }
    }
}
