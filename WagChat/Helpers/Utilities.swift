//
//  Utilities.swift
//  WagChat
//
//  Created by Tram Bui on 1/26/21.
//

import Foundation
import UIKit

class Utilities {
    
    static func styleTextField(_ textField:UITextField) {
        
    }
    
    static func styleFilledButton(_ button:UIButton) {
        button.backgroundColor = UIColor.init(red: 48/255, green: 173/255, blue: 99/255, aplha: 1)
        button.layer.cornerRadius = 20.0
        button.tintColor = UIColor.white
    }
    
    static func isPasswordValid(_ password: String) -> Bool {
        let passwordTest = NSPredicate(format: <#T##String#>, <#T##args: CVarArg...##CVarArg#>)
    }
}
