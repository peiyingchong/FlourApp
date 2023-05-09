//
//  logInViewController.swift
//  Final_App_FIT3178
//
//  Created by Chong Pei Ying  on 23/04/2023.
import SwiftUI
import UIKit
import Firebase
import FirebaseFirestore
import AuthenticationServices
import FirebaseAuth
import CryptoKit


class logInViewController: UIViewController {
    
    var currentNonce: String?

    @IBOutlet weak var emailTf: UITextField!
    
    @IBOutlet weak var passwordTf: UITextField!
    
    @IBOutlet weak var googleButton: UIButton!
    private let appleSignInButton = ASAuthorizationAppleIDButton()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        let googleLogoImage = UIImage(systemName: "g.circle.fill")!
        googleButton.setImage(googleLogoImage, for: .normal)
        
        view.addSubview(appleSignInButton)
        appleSignInButton.addTarget(self, action: #selector(startSignInWithAppleFlow), for: .touchUpInside)
      
        Auth.auth().addStateDidChangeListener { auth, user in
            //if user is signed in
            if let _ = user {
                FirebaseController().currentUser = user;
                print("SuccessfulLogin")
                self.performSegue(withIdentifier: "successfulLogin", sender: self)
            }
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //appleSignInButton.frame = CGRect(x:0,y:0,width:250, height:50)
        appleSignInButton.translatesAutoresizingMaskIntoConstraints = false
        appleSignInButton.widthAnchor.constraint(equalToConstant: 353).isActive = true
        appleSignInButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        appleSignInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        appleSignInButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -180).isActive = true
    }
    
    
    @IBAction func logInButtonTapped(_ sender: Any) {
        if FirebaseController().validateFields(emailTF: emailTf.text, passwordTF: passwordTf.text){
            FirebaseController().loginUser(withEmail: emailTf.text!, password: passwordTf.text!)
        }
    }
    
    
    @IBAction func googleButtonTapped(_ sender: Any) {
        Task { @MainActor in
            await FirebaseController().signInWithGoogle()
        }
    }
    @objc func startSignInWithAppleFlow() {
        let nonce = randomNonceString()
        currentNonce = nonce
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
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
extension logInViewController: ASAuthorizationControllerDelegate {
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
            let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                      idToken: idTokenString,
                                                      rawNonce: nonce)
            Auth.auth().signIn(with: credential) { (authResult, error) in
                if (error != nil) {
                    // Error. If error.code == .MissingOrInvalidNonce, make sure
                    // you're sending the SHA256-hashed nonce as a hex string with
                    // your request to Apple.
                    print(error?.localizedDescription ?? "")
                    return
                }
                else {
                    print("here")
                }
            }
        }
    }
func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
        print("Sign in with Apple errored: \(error)")
    }
}

extension logInViewController : ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}
    
    


    

