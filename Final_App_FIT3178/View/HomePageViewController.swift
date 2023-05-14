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
    
    var newRecipes = [RecipeData]()
    
    let url = "https://api.spoonacular.com/recipes/complexSearch?query=bread&apiKey=75fb6b5ec943413cb3932877813f3226"
    
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
        
        Task{
            //check for valid url string
            guard let urlReq = URL(string:url) else{
                print("Invalid URL")
                return
            }
            //api request
            await getRecipes(url: urlReq)
        }
        
    }
    
    
    func getRecipes(url: URL) async{
        do{
            let(data, _) = try await URLSession.shared.data(for: URLRequest(url: url))
            //create a JSONDecoder instance
            let decoder = JSONDecoder()
            
            //Because the data returned is a JsonObject, and the field wanted is an array of Json Object
            let resultContainer = try decoder.decode(SearchRecipe.self, from: data)
            
            if let recipe = resultContainer.recipes{
                for item in recipe {
                    newRecipes.append(item)
                    print(item.title)
                    print(item.id)
                    print(item.image)
                    print(item.imageType)
                }
            }
        }
        catch let error{
            print(error)
        }
    }
    
    


}
