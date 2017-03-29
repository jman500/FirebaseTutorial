//
//  SignUpViewController.swift
//  FirebaseTutorial
//
//  Created by Jim Graham on 3/14/17.
//  Copyright © 2017 JMan500. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: ValidatingViewController {
    
    // Outlets
    @IBOutlet weak var emailAddressTextField: ValidatingTextField!
    @IBOutlet weak var passwordTextField: ValidatingTextField!
    
    // Overrides and Required Implementations
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // email address
        emailAddressTextField.delegate = self
        emailAddressTextField.maxLength = 72
        emailAddressTextField.minLength = 6
        
        // password
        passwordTextField.delegate = self
        passwordTextField.maxLength = 72
        passwordTextField.minLength = 10        
    }

    // Actions
    @IBAction func createAccountAction(_ sender: Any) {
        guard let emailAddress = emailAddressTextField.text,
            let password = passwordTextField.text,
            emailAddress != "",
            password != "" else {
                    
            displayErrorAlert(message: "Please enter your email address and a password.")
                    
            return
        }
        
        var result = emailAddressTextField.validate()
        if !result.success {
            let message = generateValidatingTextFieldErrorMessage(target: emailAddressTextField,
                                                                  error: result.error)
            displayErrorAlert(message: message)
            return
        }

        result = passwordTextField.validate()
        if !result.success {
            let message = generateValidatingTextFieldErrorMessage(target: passwordTextField,
                                                                  error: result.error)
            displayErrorAlert(message: message)
            return
        }
        
        let activityIndicatorMessageView = ActivityIndicatorMessageView(message: "Creating User")
        self.view.addSubview(activityIndicatorMessageView)
        activityIndicatorMessageView.show()
        
        
        guard let auth = FIRAuth.auth() else {
            activityIndicatorMessageView.hide()
            displayErrorAlert(message: "'FIRAuth.auth()' not initialied.")

            return
        }
        
        auth.createUser(withEmail: emailAddress, password: password) {
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
}
