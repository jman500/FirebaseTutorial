//
//  SignOnViewController.swift
//  FirebaseTutorial
//
//  Created by Jim Graham on 3/14/17.
//  Copyright © 2017 JMan500. All rights reserved.
//

import UIKit
import Firebase

class SignOnViewController: UIViewController {

    // Outlets
    @IBOutlet weak var emailAddressTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    // Actions
    @IBAction func signOnAction(_ sender: Any) {
        guard let emailAddress = emailAddressTextField.text,
            let password = passwordTextField.text,
            emailAddress != "",
            password != "" else {
                
            displayErrorAlert(message: "Please enter your email address and password.")
                
            return
        }
        
        let activityIndicatorMessageView = ActivityIndicatorMessageView(message: "Signing On")
        self.view.addSubview(activityIndicatorMessageView)
        activityIndicatorMessageView.show()

        guard let auth = FIRAuth.auth() else {
            activityIndicatorMessageView.hide()
            displayErrorAlert(message: "'FIRAuth.auth()' not initialied.")
            
            return
        }

        auth.signIn(withEmail: emailAddress, password: password) {
            (user, error) in
            
            if let error = error
            {
                activityIndicatorMessageView.hide()
                // TODO: Add better verbiage for some Google Firebase Auth errors
                self.displayErrorAlert(message: error.localizedDescription)
            } else {
                guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "Home") else {
                    activityIndicatorMessageView.hide()
                    self.displayErrorAlert(message: "Unable to locate 'Home' View.")
                    
                    return
                }
                
                activityIndicatorMessageView.hide()
                self.present(vc, animated: true, completion: nil)
            }
        }
    }
    
    // Functions
    func displayErrorAlert(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
}
