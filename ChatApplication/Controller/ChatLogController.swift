//
//  ChatLogController.swift
//  ChatApplication
//
//  Created by Yash Patel on 2020-06-15.
//  Copyright © 2020 Darshan Patel. All rights reserved.
//

import UIKit
import Firebase

class ChatLogController: UICollectionViewController , UITextFieldDelegate {
    
    var user : User?{
        didSet{
            navigationItem.title = user?.name
        }
    }
    // data declared
    let db = Firestore.firestore()
    
    lazy var  inputTextField : UITextField = {
       let textField = UITextField()
        textField.placeholder = "Enter message..."
        textField.delegate = self
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        
        setupInputComponents()
    }
    
    //MARK: - container box constraints
    func setupInputComponents(){
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(containerView)
        
        // constraints for container view of new message box
        //x,y,w,h
        containerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        containerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        let sendButton = UIButton(type: .system)
        sendButton.setTitle("Send", for: .normal)
        sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(sendButton)
        
        //x,y,w,h
        sendButton.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        sendButton.heightAnchor.constraint(equalTo:containerView.heightAnchor).isActive = true
        
        containerView.addSubview(inputTextField)
        
        //x,y,w,h
        inputTextField.leftAnchor.constraint(equalTo: containerView.leftAnchor,constant: 8).isActive = true
        inputTextField.centerYAnchor.constraint(equalTo:containerView.centerYAnchor).isActive = true
        inputTextField.rightAnchor.constraint(equalTo: sendButton.leftAnchor).isActive = true
        inputTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        
        let separatorLineView = UIView()
        separatorLineView.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        separatorLineView.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(separatorLineView)
        
        //x,y,w,h
        separatorLineView.leftAnchor.constraint(equalTo:containerView.leftAnchor).isActive = true
        separatorLineView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        separatorLineView.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        separatorLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    //MARK: - send button clicked function
    @objc func handleSend(){
        guard let text = inputTextField.text else { return }
        guard let toOd = user?.id else { return }
        guard let fromId = Auth.auth().currentUser?.uid else { return}
        let timestamp : NSNumber = NSNumber(value: Int(NSDate().timeIntervalSince1970))
        let ref = db.collection(K.FstoreMessage.collectionName)
        let childRef = ref.document().documentID
        
        ref.document(childRef).setData([
            K.FstoreMessage.textField : text,
            K.FstoreMessage.toId:toOd ,
            K.FstoreMessage.fromId : fromId , 
            K.FstoreMessage.timestamp : timestamp
        ]) { (error) in
            if error != nil {
                print(error!.localizedDescription)
                return
            } else {
                print("text message saved into firebase !")

                let userMessageRef = self.db.collection(K.FstoreMessage.collectionName).document(K.FstoreMessage.userMessage).collection(fromId)
                self.db.collection(K.FstoreMessage.collectionName).document(K.FstoreMessage.userMessage).collection(fromId).document()
                let messageId = childRef
                userMessageRef.addDocument(data: [messageId:1])
            }
        }
        
        
    }
    
    //MARK: - textfield delgate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleSend()
        return true
    }
}
