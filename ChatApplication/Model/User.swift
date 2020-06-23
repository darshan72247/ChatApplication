//
//  User.swift
//  ChatApplication
//
//  Created by Yash Patel on 2020-06-09.
//  Copyright © 2020 Darshan Patel. All rights reserved.
//

import UIKit

class User: NSObject {
    var id : String?
    var name : String?
    var email : String?
    var profileImageURL : String?
    
//    init(username : String , useremail : String,profileImageUrl : String, id:String) {
//        self.name = username
//        self.email = useremail
//        self.profileImageURL = profileImageUrl
//        self.id = id
//    }
    
    init(dictionary: [String: Any]) {
        self.name = dictionary[K.FStore.nameField] as? String
        self.email = dictionary[K.FStore.emailField] as? String
        self.profileImageURL = dictionary[K.FStore.profileUrl] as? String
    }
}
