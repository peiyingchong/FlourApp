//
//  CalculatorViewController.swift
//  Final_App_FIT3178
//
//  Created by Chong Pei Ying  on 09/05/2023.
//

import UIKit
import WeatherKit
import CoreLocation
import Foundation

class CalculatorViewController: UIViewController,LocationDelegate {
    
    
    private let locationManager = LocationManager()
    
    var latitude:Double = 0.0
    var longitude:Double = 0.0
    
    var temperature: Int?
    
    @IBOutlet weak var flourInputText: UITextField!
    
    @IBOutlet weak var waterTempOutput: UILabel!
    
    var currentTemp: Double?
    
    func didUpdateLocation(latitude: Double, longitude: Double) {
        self.latitude = latitude
        print(latitude)
        self.longitude = longitude
    }
    
    @IBAction func calculateWaterTemp(_ sender: Any) {
        guard let flourTF = flourInputText.text, flourTF.isEmpty == false else {
            UIViewController().displayMessage(title: "Error", message: "Please enter a valid temperature")
            return
        }
        let flourTemp = Double(flourTF)!
        
        let latitude = locationManager.latitude
        let longitude = locationManager.longitude
        
        let url = "https://api.open-meteo.com/v1/forecast?latitude=\(latitude)&longitude=\(longitude)&hourly=temperature_2m"
        
        Task{
            await getWeather(url: URL(string: url)!)
            //because the compiler unable to type-check the equation in a reasonable time, we have to break up the equation
            // Perform the equation calculation step by step
            
            let step1 = 3 * 24
            let step2 = Double(step1) - self.currentTemp!
            let step3 = step2 - flourTemp
            let equationResult = step3 - 18
            let roundedValue = (equationResult * 10).rounded() / 10

    
            // Convert the result to a string
            let resultString = String(roundedValue)
    
            // Update the UI on the main queue
            DispatchQueue.main.async {
                self.waterTempOutput.text = "The temperature of your water should be: \(resultString)°C "
            }
        }
        
        
    }
        
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    func getWeather(url: URL) async{
        do{
            let(data, response) = try await URLSession.shared.data(for: URLRequest(url: url))
            //create a JSONDecoder instance
            let decoder = JSONDecoder()
            //hourlyData object is decoded from the JSON data using JSONDecoder
            let hourlyData = try decoder.decode(Weather_Temp_data.self, from: data)
            //get the temperature field and iterate over
            if let temperatures = hourlyData.temperature {
                //because the temperatures array contains temperature from time 00:00 to 23:59, so we have to get the particular hour
                let hour = getCurrentHour()
                let current_temp = temperatures[hour!]
                print(current_temp)
                self.currentTemp = current_temp
                print(self.self)
                }
        }
        catch let error{
            print(error)
        }
    }

    func getCurrentHour() -> Int? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH" // Format to retrieve only the hour
        
        let currentTime = Date()
        let currentHourString = dateFormatter.string(from: currentTime)
        
        let currentHour = Int(currentHourString)
        return currentHour
        
    }


}

