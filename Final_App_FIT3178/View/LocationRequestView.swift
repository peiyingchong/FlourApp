//
//  LocationRequestView.swift
//  Final_App_FIT3178
//
//  Created by Chong Pei Ying  on 08/05/2023.
//

import UIKit

class LocationRequestView: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func allowLocationButton(_ sender: Any) {
        LocationManager.shared.requestLocation()
        
    }
    
    
    @IBAction func maybeLaterButton(_ sender: Any) {
        self.performSegue(withIdentifier: "maybeLaterSegue", sender: self)
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
