//
//  Utilities.swift
//  WagChat
//


import Foundation
import UIKit

class Utilities {
    
    static func styleTextField(_ textfield:UITextField) {
        
        // Create the bottom line
        let bottomLine = CALayer()
        
        bottomLine.frame = CGRect(x: 10, y: textfield.frame.height - 2, width: textfield.frame.width - 60, height: 2)
        
        
        bottomLine.backgroundColor = UIColor.init(red: 1.0, green: 0.5, blue: 0.0, alpha: 1).cgColor
        
        // Remove border on text field
        textfield.borderStyle = .none
        
        // Add the line to the text field
        textfield.layer.addSublayer(bottomLine)
        
    }
    
    static func styleFilledButton(_ button:UIButton) {
        
        // Filled rounded corner style
        button.backgroundColor = UIColor.init(red: 1.0, green: 0.5, blue: 0.0, alpha: 1)
        button.layer.cornerRadius = 25.0
        button.tintColor = UIColor.white
    }
    
    static func styleFilledButtonCornerRadius(_ button:UIButton) {
        button.layer.cornerRadius = 25.0
        button.backgroundColor = #colorLiteral(red: 0.1325967501, green: 0.3743020498, blue: 1, alpha: 1)
        
//        let icon = UIImage(named: "google-1")!
//           button.setImage(icon, for: .normal)
//           button.imageView?.contentMode = .scaleAspectFit
//           button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -40, bottom: 0, right: 0)
        
        
    }
    
    static func styleFilledLogin(_ button:UIButton) {
        button.layer.cornerRadius = 25.0
        button.backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
        
        
    }
    
    static func styleHollowButton(_ button:UIButton) {
        
        // Hollow rounded corner style
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.cornerRadius = 25.0
        button.tintColor = UIColor.black
    }
    
    static func isPasswordValid(_ password : String) -> Bool {
        
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
    }
    
}
