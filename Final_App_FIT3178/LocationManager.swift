//
//  LocationManager.swift
//  Final_App_FIT3178
//
//  Created by Chong Pei Ying  on 08/05/2023.
//

import Foundation
import CoreLocation
import UIKit
import WeatherKit

class LocationManager:NSObject, CLLocationManagerDelegate {
    
    var delegate: LocationDelegate?
    //manages our location services such as requesting user location
    
    //conforms to theCLLocationManager Delegate
    static let shared = LocationManager()
    
    //to request location services from the user
    private let manager = CLLocationManager()
    
    //if user location is not allowed, the request screen will pop up. If user allows, then we want to dismiss the screen and take the another scrren
    @Published var userLocation: CLLocation?
    
    
    
    override init(){
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.startUpdatingLocation()
    }
    func requestLocation(){
        manager.requestWhenInUseAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
            
        case .notDetermined:
            print("DEBUG: notDetermined")
        case .restricted:
            print("DEBUG: Restricted")
        case .denied:
            print("DEBUG: Denied")
        case .authorizedAlways:
            print("DEBUG: Auth always")
        case .authorizedWhenInUse:
            print("DEBUG: Auth in use")
        @unknown default:
            break
        }
    }
    //when we get user location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        //which is the most up-to-date location position.
        guard let location = locations.last else {return}
        self.userLocation = location
        let currentLocation = location.coordinate
        let latitude = currentLocation.latitude
        print("latitude: \(latitude)" )
        let longitude = currentLocation.longitude
        print("longitude: \(longitude)" )
        self.delegate?.didUpdateLocation(latitude: latitude, longitude: longitude)
        

    }
    
    
    
    
    
}

protocol LocationDelegate: NSObject {
    func didUpdateLocation(latitude: Double, longitude: Double)
}
