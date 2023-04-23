//
//  DisplayMessage.swift
//  Final_App_FIT3178
//
//  Created by Chong Pei Ying  on 23/04/2023.
//
import UIKit
 
extension UIViewController {
    func displayMessage(title: String, message: String) {

            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            FirebaseController().getTopMostViewController()?.present(alertController, animated: true, completion: nil)
    }
    
    
}

