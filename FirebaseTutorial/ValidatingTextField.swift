//
//  ValidatingTextField.swift
//  FirebaseTutorial
//
//  Created by Jim Graham on 3/19/17.
//  Copyright © 2017 JMan500. All rights reserved.
//

import UIKit

class ValidatingTextField: UITextField {

    // Enums
    enum ErrorCode: Error {
        case textCharacaterLengthIsTooLong
        case textCharacaterLengthIsTooShort
        
        var localizedDescription: String {
            switch self {
            case .textCharacaterLengthIsTooLong:
                return "The field is longer than the allowed character length."
            case .textCharacaterLengthIsTooShort:
                return "The field does not meet the minimum required character length."
            }
        }
    }
    
    // Variables
    private var checkAllowedCharacters: Bool = false
        
    // Properties
    var maxLength: Int = Int.max
    var minLength: Int = 0
    
    var charactersAllowed: String = "" {
        didSet {
            checkAllowedCharacters = true
        }
    }
    
    var charactersDisallowed: String = "" {
        didSet {
            checkAllowedCharacters = false
        }
    }
    
    // Overrides and Required Implementations
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // Functions
    func validateOnEdit(shouldChangeCharactersIn range: NSRange, replacementString: String) ->
        (success: Bool, error: ErrorCode?) {
        
        guard replacementString.characters.count > 0 else {
            return (true, nil)
        }
        
        let currentText = text ?? ""
        let prospectiveText = (currentText as NSString).replacingCharacters(in: range, with: replacementString)
        
        if prospectiveText.characters.count <= maxLength {
            return (true, nil)
        } else {
            return (false, ErrorCode.textCharacaterLengthIsTooLong)
        }
            
        // TODO: Implement allowed and disallowed character checks
        
    }
    
    func validate() -> (success: Bool, error: ErrorCode?) {
        let text = self.text ?? ""
        
        if text.characters.count < minLength {
            return (false, ErrorCode.textCharacaterLengthIsTooShort)
        }
        
        if text.characters.count > maxLength {
            return (false, ErrorCode.textCharacaterLengthIsTooLong)
        }
        
        // TODO: Implement allowed and disallowed character checks
        
        return (true, nil)
    }
}
