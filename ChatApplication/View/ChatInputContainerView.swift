//
//  ChatInputContainerView.swift
//  ChatApplication
//
//  Created by Yash Patel on 2020-06-26.
//  Copyright © 2020 Darshan Patel. All rights reserved.
//

import UIKit

class ChatInputContainerView : UIView , UITextFieldDelegate{
    
    var chatLogController:ChatLogController?{
        didSet{
            sendButton.addTarget(chatLogController, action: #selector(ChatLogController.handleSend), for: .touchUpInside)
//            sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
            uploadImageView.addGestureRecognizer(UITapGestureRecognizer(target: chatLogController, action: #selector(ChatLogController.handleUploadTap)))
//            uploadImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleUploadTap)))
        }
    }
    
    let sendButton = UIButton(type: .system)
    
    lazy var  inputTextField : UITextField = {
           let textField = UITextField()
           textField.placeholder = "Enter message..."
           textField.delegate = self
           textField.translatesAutoresizingMaskIntoConstraints = false
           return textField
       }()
    
    let uploadImageView : UIImageView = {
        let uploadImageView = UIImageView()
        uploadImageView.isUserInteractionEnabled = true
        uploadImageView.image = UIImage(named: "image")
        uploadImageView.translatesAutoresizingMaskIntoConstraints = false
        return uploadImageView
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
       
        addSubview(uploadImageView)
        // what is handleUploadTap
        
        //x,y,w,h
        uploadImageView.leftAnchor.constraint(equalTo : leftAnchor ,constant: 8).isActive = true
        uploadImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        uploadImageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        uploadImageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        
        sendButton.setTitle("Send", for: .normal)
        // what is handle send
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(sendButton)
        
        //x,y,w,h
        sendButton.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        sendButton.heightAnchor.constraint(equalTo:heightAnchor).isActive = true
        
        addSubview(inputTextField)
        
        //x,y,w,h
        inputTextField.leftAnchor.constraint(equalTo: uploadImageView.rightAnchor,constant: 8).isActive = true
        inputTextField.centerYAnchor.constraint(equalTo:centerYAnchor).isActive = true
        inputTextField.rightAnchor.constraint(equalTo: sendButton.leftAnchor).isActive = true
        inputTextField.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        
        let separatorLineView = UIView()
        separatorLineView.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        separatorLineView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(separatorLineView)
        
        //x,y,w,h
        separatorLineView.leftAnchor.constraint(equalTo:leftAnchor).isActive = true
        separatorLineView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        separatorLineView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        separatorLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    //MARK: - textfield delgate
       func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        chatLogController?.handleSend()
           return true
       }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
