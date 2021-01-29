//
//  chat.swift
//  WagChat
//
//  Created by Ada on 1/29/21.

// store chat object in this file

import UIKit

// creat struct with 2 variable
struct Chat {
    
    var users: [String]
    
   // returning dictionary of chat object
    var dictionary: [String: Any] {
        return [
            "users": users
        ]
    }
}

// add new functionality - add initializer
extension Chat {
    
    init?(dictionary: [String:Any]) {
        // add guard to make sure it's not nil
        // initialize the class with users
        guard let chatUsers = dictionary["users"] as? [String] else {return nil}
        self.init(users: chatUsers)
    }
    
}
