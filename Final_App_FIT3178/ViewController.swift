//
//  ViewController.swift
//  Final_App_FIT3178
//
//  Created by Chong Pei Ying  on 23/04/2023.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

    var locationManager: CLLocationManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        //set ourself as the delegate, so we need to conform to the protocol
        locationManager?.delegate = self
        //
        locationManager?.requestAlwaysAuthorization()
        
        // Do any additional setup after loading the view.
    }


}

