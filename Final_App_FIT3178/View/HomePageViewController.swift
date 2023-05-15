//
//  HomePageViewController.swift
//  Final_App_FIT3178
//
//  Created by Chong Pei Ying  on 25/04/2023.
//

import UIKit
import CoreLocation

class HomePageViewController: UIViewController{
    
    private let locationManager = CLLocationManager()
    
    
    
    @IBAction func toCalculatorPage(_ sender: Any) {
        self.performSegue(withIdentifier: "calculatorSegue", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let locationManager = CLLocationManager()
        DispatchQueue.global().async {
            if CLLocationManager.locationServicesEnabled() {
                switch locationManager.authorizationStatus {
                    case .notDetermined, .restricted:
                    LocationManager.shared.requestLocation()
//                        DispatchQueue.main.async {
//                            self.performSegue(withIdentifier: "requestLocationAccessSegue", sender: self)
//                        }
                    case .denied:
                        print("denied")
                    case .authorizedAlways, .authorizedWhenInUse:
                        DispatchQueue.main.async {
                            self.dismiss(animated: true, completion: nil)
                        }
                    @unknown default:
                        break
                }
            } else {
                print("Location services are not enabled")
            }
        }
        
        
    }
    
    
   
    
    


}
