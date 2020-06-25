//
//  Constants.swift
//  ChatApplication
//
//  Created by Yash Patel on 2020-06-07.
//  Copyright © 2020 Darshan Patel. All rights reserved.
//

import Foundation

struct K {
    
    static let newMessageCellIdentifier = "cellId"
    struct FStore {
        static let collectionName = "users"
        static let nameField = "name"
        static let emailField = "email"
        static let uidField = "uid"
        static let profileUrl = "profileImageUrl"
    }
    struct FstoreMessage {
        static let collectionName = "messages"
        static let textField = "text"
        static let imageUrlField = "imageUrl"
        static let videoUrlField = "VideoUrl"
        static let imageWidth = "imageWidth"
        static let imageHeigt = " imageHeight"
        static let fromId = "fromId"
        static let toId = "toId"
        static let timestamp = "timestamp"
        static let userMessage = "user-messages"
    }
}
