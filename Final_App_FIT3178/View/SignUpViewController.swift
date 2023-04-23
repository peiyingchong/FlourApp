//
//  SignUpViewController.swift
//  Final_App_FIT3178
//
//  Created by Chong Pei Ying  on 23/04/2023.
//

import UIKit
import FirebaseAuth
import GoogleSignIn
import Firebase

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var emailTf: UITextField!
    
    @IBOutlet weak var passwordTf: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func signUpButtonTapped(_ sender: Any) {
        if FirebaseController().validateFields(emailTF: emailTf.text, passwordTF: passwordTf.text){
            FirebaseController().signUpUser(withEmail: emailTf.text!, password: passwordTf.text!)
        }
    }
    
    @IBAction func googleButtonTapped(_ sender: Any) {
        Task { @MainActor in
            await FirebaseController().signInWithGoogle()
        }
    }
    
    @IBAction func appleButtonTapped(_ sender: Any) {
    }
}


