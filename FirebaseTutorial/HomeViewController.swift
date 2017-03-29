//
//  HomeViewController.swift
//  FirebaseTutorial
//
//  Created by Jim Graham on 3/14/17.
//  Copyright © 2017 JMan500. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: UIViewController {
    
    // Actions
    @IBAction func signOffAction(_ sender: Any) {
        let activityIndicatorMessageView = ActivityIndicatorMessageView(message: "Signing Off")
        self.view.addSubview(activityIndicatorMessageView)
        activityIndicatorMessageView.show()
        
        guard let auth = FIRAuth.auth() else {
            activityIndicatorMessageView.hide()
            displayErrorAlert(message: "'FIRAuth.auth()' not initialied.")
            
            return
        }
        
        if auth.currentUser != nil {
            do {
                try auth.signOut()
                
                guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "SignOn") else {
                    activityIndicatorMessageView.hide()
                    self.displayErrorAlert(message: "Unable to locate 'SignOn' View.")
                    
                    return
                }
                
                activityIndicatorMessageView.hide()
                self.present(vc, animated: true, completion: nil)
            } catch let error as NSError {
                activityIndicatorMessageView.hide()
                self.displayErrorAlert(message: error.localizedDescription)
            }
        } else {
            activityIndicatorMessageView.hide()
            displayErrorAlert(message: "Unable to get current user.")
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
