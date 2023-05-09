//
//  HomePageViewController.swift
//  Final_App_FIT3178
//
//  Created by Chong Pei Ying  on 25/04/2023.
//

import UIKit
import CoreLocation

class HomePageViewController: UIViewController {
    
    private let locationManager = CLLocationManager()
    
    
    @IBAction func toCalculatorPage(_ sender: Any) {
        self.performSegue(withIdentifier: "calculatorSegue", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let locationManager = CLLocationManager()
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways, .authorizedWhenInUse:
            // Location access is enabled, perform segue to calculator
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "calculatorSegue", sender: self)
            }
        case .denied, .restricted:
            // Location access is denied or restricted, show message
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Location access denied", message: "Please enable location access in Settings.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true)
            }
        case .notDetermined:
            // Location access is not determined, request access
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "requestLocationAccessSegue", sender: self)
            }
            
            
        }
        
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
