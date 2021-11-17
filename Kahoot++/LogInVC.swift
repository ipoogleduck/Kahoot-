//
//  ViewController.swift
//  Kahoot++
//
//  Created by Oliver Elliott on 11/8/21.
//

import UIKit
import Firebase
import CryptoKit
import AuthenticationServices

var isStudent = true
var id = "435672"

class LogInVC: UIViewController {
    
    fileprivate var currentNonce: String?

    @IBOutlet var segmentedControl: UISegmentedControl!
    @IBOutlet var mainTitle: UILabel!
    
    @IBOutlet var SIWABackground: UIView!
    @IBOutlet var SIWALogo: UIImageView!
    @IBOutlet var SIWALabel: UILabel!
    @IBOutlet var SIWAButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SIWABackground.layer.cornerRadius = 7
    }
    
    @objc func signInWithAppleButtonTapped() {
        startSignInWithAppleFlow()
    }
    
    func startSignInWithAppleFlow() {
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
    
    @IBAction func segmentedControlChanged(_ sender: Any) {
        if segmentedControl.selectedSegmentIndex == 0 {
            mainTitle.text = "Log in as a Student to Join Classes"
            isStudent = true
        } else {
            mainTitle.text = "Log in as a Teacher to Create Content"
            isStudent = false
        }
    }
    
    
    @IBAction func appleSignInTouchesBegan(_ sender: Any) {
        //Start animations
        animateSignInButton(tapped: true)
    }
    
    @IBAction func applpeSignInTouchesCanceled(_ sender: Any) {
        //End animations
        animateSignInButton(tapped: false)
    }
    
    @IBAction func appleSignInTapped(_ sender: Any) {
        //End animations
        animateSignInButton(tapped: false)
        //Sign In
        startSignInWithAppleFlow()
    }
    
    func animateSignInButton(tapped: Bool) {
        UIView.animate(withDuration: 0.2, animations: {
            if tapped {
                switch self.traitCollection.userInterfaceStyle {
                case .dark:
                    self.SIWABackground.backgroundColor = UIColor(named: "buttonPressGray")
                case _:
                    self.SIWALogo.tintColor  = .lightGray
                    UIView.transition(with: self.SIWALabel, duration: 0.2, options: .transitionCrossDissolve, animations: {
                        self.SIWALabel.textColor = UIColor.lightGray
                    }, completion: nil)
                }
            } else {
                self.SIWABackground.backgroundColor = .label
                self.SIWALogo.tintColor  = .systemBackground
                UIView.transition(with: self.SIWALabel, duration: 0.2, options: .transitionCrossDissolve, animations: {
                    self.SIWALabel.textColor = UIColor.systemBackground
                }, completion: nil)
            }
        })
    }


}

@available(iOS 13.0, *)
private func sha256(_ input: String) -> String {
    let inputData = Data(input.utf8)
    let hashedData = SHA256.hash(data: inputData)
    let hashString = hashedData.compactMap {
        return String(format: "%02x", $0)
    }.joined()
    
    return hashString
}

// Adapted from https://auth0.com/docs/api-auth/tutorials/nonce#generate-a-cryptographically-random-nonce
private func randomNonceString(length: Int = 32) -> String {
    precondition(length > 0)
    let charset: Array<Character> =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
    var result = ""
    var remainingLength = length
    
    while remainingLength > 0 {
        let randoms: [UInt8] = (0 ..< 16).map { _ in
            var random: UInt8 = 0
            let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
            if errorCode != errSecSuccess {
                fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
            }
            return random
        }
        
        randoms.forEach { random in
            if remainingLength == 0 {
                return
            }
            
            if random < charset.count {
                result.append(charset[Int(random)])
                remainingLength -= 1
            }
        }
    }
    
    return result
}

extension LogInVC: ASAuthorizationControllerPresentationContextProviding {
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        self.view.window!
    }
    
}

extension LogInVC: ASAuthorizationControllerDelegate {
    
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
            // Initialize a Firebase credential.
            let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                      idToken: idTokenString,
                                                      rawNonce: nonce)
            // Sign in with Firebase.
            Auth.auth().signIn(with: credential) { (authResult, error) in
                if (error != nil) {
                    // Error. If error.code == .MissingOrInvalidNonce, make sure
                    // you're sending the SHA256-hashed nonce as a hex string with
                    // your request to Apple.
                    print(error?.localizedDescription ?? "Err")
                    return
                }
                if let user = authResult?.user {
                    if let fullName = appleIDCredential.fullName {
                        if let givenName = fullName.givenName, let familyName = fullName.familyName {
                            let changeRequest = user.createProfileChangeRequest() // (3)
                            changeRequest.displayName = "\(givenName) \(familyName)"
                            changeRequest.commitChanges(completion: { error in
                                if let error = error {
                                    print("Error with commiting user account name update: \(error)")
                                    return
                                }
                                print("Success updating name")
                            })
                        }
                    }
                }
                //Go to next VC
                self.performSegue(withIdentifier: "signInToMainSegue", sender: self)
            }
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
        print("Sign in with Apple errored: \(error)")
    }
    
}


