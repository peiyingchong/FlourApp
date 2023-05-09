//
//  CalculatorViewController.swift
//  Final_App_FIT3178
//
//  Created by Chong Pei Ying  on 09/05/2023.
//

import UIKit
import WeatherKit
import CoreLocation

class CalculatorViewController: UIViewController,LocationDelegate {
    
    let service = WeatherService()
    
    private let locationManager = LocationManager()
    
    var latitude:Double?
    var longitude:Double?

    @IBOutlet weak var flourInputText: UITextField!
    
    @IBOutlet weak var waterTempOutput: UILabel!
    
    @IBAction func calculateWaterTemp(_ sender: Any) {
        guard let flourTF = flourInputText.text, flourTF.isEmpty == false else {
            UIViewController().displayMessage(title: "Error", message: "Please enter a valid temperature")
            return
        }
        
        let flourTemp = Double(flourTF)!
        guard let latitude = self.latitude else {return }
        guard let longitude = self.longitude else {return}
        let location = CLLocation(latitude: latitude, longitude: longitude)
        
        Task {
            do { let weather = try await service.weather(for: location)
                let currentWeather = CurrentWeather(
                    temperature: weather.currentWeather.temperature.value)
                let waterTemp =  3 * 24 - currentWeather.temperature - flourTemp - 18
                print("here")
                print(waterTemp)
                waterTempOutput.text = String(waterTemp)
            }
            catch {
                assertionFailure(error.localizedDescription)
            }}
        
    struct CurrentWeather {
            
        let temperature: Double
        
    }
        
        
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    func didUpdateLocation(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
