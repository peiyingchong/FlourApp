//
//  SignUpViewController.swift
//  Final_App_FIT3178
//
//  Created by Chong Pei Ying  on 23/04/2023.
//
import SwiftUI
import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore
import AuthenticationServices
import CryptoKit

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var emailTf: UITextField!
    
    @IBOutlet weak var passwordTf: UITextField!
    
    
    @IBOutlet weak var googleButton: UIButton!
    
    private let appleSignInButton = ASAuthorizationAppleIDButton()
    
    fileprivate var currentNonce: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let googleLogoImage = UIImage(systemName: "g.circle.fill")!
        googleButton.setImage(googleLogoImage, for: .normal)
        
        view.addSubview(appleSignInButton)
        appleSignInButton.addTarget(self, action: #selector(startSignInWithAppleFlow), for: .touchUpInside)
        
        Auth.auth().addStateDidChangeListener { auth, user in
            //if user is signed in
            if let user = user {
                FirebaseController().currentUser = user;
                self.performSegue(withIdentifier: "succesful_login_segue", sender: self)
            }
        }

        
    }
    
    // with viewDidLayoutSubviews, it only take places after all the auto layout or auto resizing calculations on the views have been applied.
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //appleSignInButton.frame = CGRect(x:0,y:0,width:250, height:50)
        appleSignInButton.translatesAutoresizingMaskIntoConstraints = false
        appleSignInButton.widthAnchor.constraint(equalToConstant: 353).isActive = true
        appleSignInButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        appleSignInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        appleSignInButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -180).isActive = true
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
    @objc func startSignInWithAppleFlow() {
        //generates a random string that will be used to validate the identity token later, prevent replay attacks
        let nonce = randomNonceString()
        currentNonce = nonce
        //request authorization from the user to access their Apple ID.
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        //configure the authorization request //ASAuthorizationAppleIDRequest
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)
        
        //passing in an array of ASAuthorizationRequest
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        //current object conforms to the ASAuthorizationControllerDelegate protocol and will handle the authorization response.
        authorizationController.delegate = self
        //will provide the context for presenting the authorization UI.
        authorizationController.presentationContextProvider = self
        // initiate the authorization process.
        authorizationController.performRequests()
        
    }
    
    private func randomNonceString(length: Int = 32) -> String {
      precondition(length > 0)
      var randomBytes = [UInt8](repeating: 0, count: length)
      let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
      if errorCode != errSecSuccess {
        fatalError(
          "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
        )
      }

      let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")

      let nonce = randomBytes.map { byte in
        // Pick a random character from the set, wrapping around if needed.
        charset[Int(byte) % charset.count]
      }

      return String(nonce)
    }
    
    private func sha256(_ input: String) -> String {
      let inputData = Data(input.utf8)
      let hashedData = SHA256.hash(data: inputData)
      let hashString = hashedData.compactMap {
        String(format: "%02x", $0)
      }.joined()

      return hashString
    }
}

extension SignUpViewController: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = currentNonce else {
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Unable to fetch identity token")
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                return
            }
            print("7")
            
            //Initialize a Firebase credential, including the user's full name.
            let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                      idToken: idTokenString,
                                                      rawNonce: nonce)
            
            // Sign in with Firebase
            Task {
                do{
                    let result = try await Auth.auth().signIn(with: credential)
                }
                catch{
                    print("Error authenticating: \(error.localizedDescription)")
                }}
        }
        
    }
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
        print("Sign in with Apple errored: \(error)")
    }
}

extension SignUpViewController : ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}
    
    

