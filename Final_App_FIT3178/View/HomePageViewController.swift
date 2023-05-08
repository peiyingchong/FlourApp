//
//  HomePageViewController.swift
//  Final_App_FIT3178
//
//  Created by Chong Pei Ying  on 25/04/2023.
//

import UIKit
import CoreLocation

class HomePageViewController: UIViewController {
    
    
    var locationManager = LocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if locationManager.userLocation == nil {
            LocationRequestView()
        }
        else{
            HomePageViewController()
        }
    }
    
    func getImages() {
        
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
