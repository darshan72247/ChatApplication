//
//  Message.swift
//  ChatApplication
//
//  Created by Yash Patel on 2020-06-18.
//  Copyright © 2020 Darshan Patel. All rights reserved.
//

import UIKit
import Firebase

class Message: NSObject {

    var fromId : String?
    var text : String?
    var timestamp : NSNumber?
    var toId : String?
    
//    init(_ formId:String , _ text:String,_ timestamp : NSNumber , _ toId : String) {
//        self.fromId = formId
//        self.text = text
//        self.timestamp = timestamp
//        self.toId = toId
//    }
    init(dictionary: [String: Any]) {
        self.text = dictionary[K.FstoreMessage.textField] as? String
        self.toId = dictionary[K.FstoreMessage.toId] as? String
        self.fromId = dictionary[K.FstoreMessage.fromId] as? String
        self.timestamp = dictionary[K.FstoreMessage.timestamp] as? NSNumber
    }
    
    func chatPartnerId() -> String? {
        return fromId == Auth.auth().currentUser?.uid ? toId : fromId
//
//        if fromId == Auth.auth().currentUser?.uid{
//            return toId
//        } else {
//            return fromId
//        }
    }

}
