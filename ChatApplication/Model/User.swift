//
//  User.swift
//  ChatApplication
//
//  Created by Yash Patel on 2020-06-09.
//  Copyright © 2020 Darshan Patel. All rights reserved.
//

import UIKit

class User: NSObject {
    var name : String?
    var email : String?
    
     init(username : String , useremail : String) {
        self.name = username
        self.email = useremail
    }
}
