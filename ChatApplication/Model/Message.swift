//
//  Message.swift
//  ChatApplication
//
//  Created by Yash Patel on 2020-06-18.
//  Copyright © 2020 Darshan Patel. All rights reserved.
//

import UIKit

class Message: NSObject {

    var formId : String?
    var text : String?
    var timestamp : NSNumber?
    var toId : String?
    
    init(_ formId:String , _ text:String,_ timestamp : NSNumber , _ toId : String) {
        self.formId = formId
        self.text = text
        self.timestamp = timestamp
        self.toId = toId
    }
}
