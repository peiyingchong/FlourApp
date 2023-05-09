//
//  SignInMethod.swift
//  Final_App_FIT3178
//
//  Created by Chong Pei Ying  on 23/04/2023.
//


import UIKit
import FirebaseAuth
import GoogleSignIn
import Firebase
import CryptoKit
import AuthenticationServices

class FirebaseController {
    
    var currentUser: FirebaseAuth.User?
  
    
    
    func signInWithGoogle() async {
        //tries to get an instance of Firebase, then accesing the clientID property of options
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        // Create Google Sign In configuration object using clientID provided by Firebase SDK
        //GIDConfiguration: a class provided by google sdk
        let config = GIDConfiguration(clientID: clientID)
        //this singleton class GISignIn.sharedInstance
        GIDSignIn.sharedInstance.configuration = config
        
        //ensure if user stops sign in, or finishes signing in, the go back to wherever they were in the app
        guard let rootVC = self.getTopMostViewController() else {
            print("There is no root view controller")
            return
        }
        
        // Start the sign in flow, using asynchronous
        do {
            let userAuthentication = try await GIDSignIn.sharedInstance.signIn(withPresenting:rootVC)
            let user = userAuthentication.user
            guard let idToken = user.idToken else{
                return
            }
            let accessToken = user.accessToken
            //create a credential that can be used for firebase authentication
            let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString, accessToken: accessToken.tokenString)
            //truing to authenticate using firebase
            let result = try await Auth.auth().signIn(with: credential)
            self.currentUser = Auth.auth().currentUser
        }
        catch {
            print(error.localizedDescription)
            return
        }
            
        
        
    }
    
    func validateEmail(enteredEmail: String) -> Bool {

        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: enteredEmail)

    }
    
    func validateFields(emailTF: String?, passwordTF: String?) -> Bool {
        guard let email = emailTF, email.isEmpty == false, self.validateEmail(enteredEmail: email) else {
            UIViewController().displayMessage(title: "Error", message: "Please enter a valid email")
            return false
        }
        guard let password = passwordTF, password.isEmpty == false else {
            UIViewController().displayMessage(title: "Error", message: "Please enter a valid password")
            return false
        }
        return true
    }
    
    func loginUser(withEmail email: String, password: String) {
        Auth.auth().signIn(withEmail: email,password: password) { (user, error) in
            if (error != nil) {
                print(error!.localizedDescription)

            }
            else{
                self.currentUser = Auth.auth().currentUser
                return
            }
        }
    }
    
    func signUpUser(withEmail email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if (error != nil) {
                    if password.count < 6 {
                        UIViewController().displayMessage(title: "Error", message: "Password must be more than 6 characters")
                    }else{
                        print(error!.localizedDescription)}
                }
                else{
                    self.currentUser = Auth.auth().currentUser
                    return
                   
                }
        }
    }
    
    func getTopMostViewController() -> UIViewController? {
            var topMostViewController = UIApplication.shared.keyWindow?.rootViewController

            while let presentedViewController = topMostViewController?.presentedViewController {
                topMostViewController = presentedViewController
            }

            return topMostViewController
        }
    
    
    
}

