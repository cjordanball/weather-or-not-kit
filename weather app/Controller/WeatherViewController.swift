//
//  ViewController.swift
//  weather app
//
//  Created by C. Jordan Ball III on 7/16/21.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {

    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var waitMessage: UILabel!
    @IBOutlet weak var tempStack: UIStackView!
    
    @IBAction func onSearchTouch(_ sender: UITextField) {
        searchTextField.text = "";
    }
    @IBAction func checkLocation(_ sender: Any) {
        locationManager.requestLocation();
        setWaitView();
    }
    
    var weatherManager = WeatherManager();
    var locationManager = CLLocationManager();
    
    override func viewDidLoad() {
        super.viewDidLoad();
        self.conditionImageView.tintColor = UIColor.black;
        
        searchTextField.delegate = self;
        weatherManager.weatherDelegate = self;
        locationManager.delegate = self;
        
        locationManager.requestWhenInUseAuthorization();
        locationManager.requestLocation();
        
        tempStack.alpha = 0.0;
        cityLabel.alpha = 0.0;
        
    }
    
    func setWaitView() {
        tempStack.alpha = 0.0;
        cityLabel.alpha = 0.0;
        conditionImageView.alpha = 0.0;
        waitMessage.alpha = 1.0;
    }
    
    func removeWaitView() {
        tempStack.alpha = 1.0;
        cityLabel.alpha = 1.0;
        conditionImageView.alpha = 1.0;
        waitMessage.alpha = 0.0;
    }
}

extension WeatherViewController: UITextFieldDelegate {
    
    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true);
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true);
        return true;
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let city = searchTextField.text {
            weatherManager.fetchWeather(cityName: city);
        }
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if (textField.text != "") {
            return true;
        } else {
            textField.placeholder = "City search";
            return false
        };
    }
}

extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let lat = location.coordinate.latitude;
            let lng = location.coordinate.longitude;
            weatherManager.fetchWeather(lat: lat, lng: lng);
        };
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription);
    }
}

extension WeatherViewController: WeatherManagerDelegate {
    // set up didUpdateWeather
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        DispatchQueue.main.async {
            self.tempLabel.text = weather.tempString;
            self.cityLabel.text = weather.cityName;
            self.conditionImageView.image = UIImage(systemName: weather.conditionName);
//            if let waiter = self.waitMessage {waiter.removeFromSuperview()};
            self.removeWaitView();
        }

    }
    
    // set up didFailWithError
    func didFailWithError(error: Error) {
        print("ERROR: \(error.localizedDescription)");
    }
}

