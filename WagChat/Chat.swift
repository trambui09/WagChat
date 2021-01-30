//
//  Chat.swift
//  WagChat
//
//  Created by Tram Bui on 1/29/21.
//

import Foundation
import UIKit

struct Chat {
    var users: [String]
    
    var dictionary: [String: Any] {
        return ["users": users]
    }
}

extension Chat {
    init?(dictionary: [String:Any]) {
        guard let chatUsers = dictionary["users"] as? [String] else {
            return nil
        }
        self.init(users: chatUsers)
    }
}
