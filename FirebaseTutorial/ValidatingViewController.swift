//
//  ValidatingViewController.swift
//  FirebaseTutorial
//
//  Created by Jim Graham on 3/28/17.
//  Copyright © 2017 JMan500. All rights reserved.
//

import UIKit

class ValidatingViewController: UIViewController, UITextFieldDelegate {

    // Overrides and Required Implementations
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if let target = textField as? ValidatingTextField {
            let result = target.validateOnEdit(shouldChangeCharactersIn: range, replacementString: string)
            
            if result.success {
                return true
            } else {
                let message = generateValidatingTextFieldErrorMessage(target: target, error: result.error)
                displayErrorAlert(message: message)
                
                return false
            }
        }
        
        return true
    }
    
    // Functions
    func displayErrorAlert(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func generateValidatingTextFieldErrorMessage(target: ValidatingTextField, error: ValidatingTextField.ErrorCode?) -> String {
        
        guard let error = error else {
            return "Unknown error during validation."
        }
        
        let fieldDescription = target.placeholder ?? "[Unknown Field]"
        var message = ""
        
        switch error as ValidatingTextField.ErrorCode {
        case .textCharacaterLengthIsTooLong:
            message = "The maximum length allowed for your \(fieldDescription) is \(target.maxLength) characters. "
        case .textCharacaterLengthIsTooShort:
            message = "The minumum length required for your \(fieldDescription) is \(target.minLength) characters. " + error.localizedDescription
        }
        
        return message
    }
}
