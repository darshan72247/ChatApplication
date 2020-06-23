//
//  ChatLogController.swift
//  ChatApplication
//
//  Created by Yash Patel on 2020-06-15.
//  Copyright © 2020 Darshan Patel. All rights reserved.
//

import UIKit
import Firebase

class ChatLogController: UICollectionViewController , UITextFieldDelegate , UICollectionViewDelegateFlowLayout {
    
    var user : User?{
        didSet{
            navigationItem.title = user?.name
            
            obsereveMessages()
        }
    }
    
    var messages = [Message]()
    
    func obsereveMessages(){
//        messages.removeAll()
//        DispatchQueue.main.async {
//            self.collectionView.reloadData()
//        }

        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let userMessageRef = db.collection(K.FstoreMessage.collectionName).document(uid).collection("user-messages")
        userMessageRef.addSnapshotListener { (snapshot, error) in
            if error != nil {
                print(error!.localizedDescription)
                return
            }
            if let data = snapshot?.documents{
                for values in data{
                    //print(values.data())
                    let messageData = values.data()
                    for elements in messageData{
                        let messageId = elements.key
                        let messagesRef = self.db.collection(K.FstoreMessage.collectionName).document(messageId)
                        messagesRef.addSnapshotListener { (snapshot, error) in
                            if error != nil {
                                print(error!.localizedDescription)
                                return
                            }
                            if let data = snapshot?.data(){
                                //print(data)
                                let message = Message(dictionary: data)
                               // print(message.text)
                                if message.chatPartnerId() == self.user?.id{
                                    self.messages.append(message)
                                    
                                    DispatchQueue.main.async {
                                        self.collectionView.reloadData()
                                    }
                                }
                            }
                        }
                    }
                    
                }
            }
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
        collectionView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 58, right: 0)
        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        collectionView.register(ChatMessageCell.self, forCellWithReuseIdentifier: K.newMessageCellIdentifier)
        collectionView.alwaysBounceVertical = true 
        
        setupInputComponents()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.newMessageCellIdentifier, for: indexPath) as! ChatMessageCell
        let message = messages[indexPath.row]
        cell.textView.text = message.text
        
        cell.bubbleWidthAnchor?.constant = estimateFrameForText(text: message.text!).width + 32
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height:CGFloat = 80
        
        if let text = messages[indexPath.row].text{
            height = estimateFrameForText(text: text).height + 20
        }
        
        return CGSize(width: view.frame.width, height: height)
    }
    
    private func estimateFrameForText(text : String) -> CGRect{
        let size = CGSize(width: 200, height: 1000)
        
        let option = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        
        
        return NSString(string: text).boundingRect(with: size, options: option, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16)], context: nil)
    }
    //MARK: - container box constraints
    func setupInputComponents(){
        let containerView = UIView()
        containerView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0) 
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
        guard let toId = user?.id else { return }
        guard let fromId = Auth.auth().currentUser?.uid else { return}
        let timestamp : NSNumber = NSNumber(value: Int(NSDate().timeIntervalSince1970))
        let ref = db.collection(K.FstoreMessage.collectionName)
        let messageId = ref.document().documentID
        
        ref.document(messageId).setData([
            K.FstoreMessage.textField : text,
            K.FstoreMessage.toId:toId ,
            K.FstoreMessage.fromId : fromId , 
            K.FstoreMessage.timestamp : timestamp
        ]) { (error) in
            if error != nil {
                print(error!.localizedDescription)
                return
            } else {
                self.inputTextField.text = nil
                print("text message saved into firebase !")

                //saving data with refrence for current user
                self.db.collection(K.FstoreMessage.collectionName).document(fromId).collection(K.FstoreMessage.userMessage).document(toId).setData([messageId : 1], merge: true)
                
                // saving data for recipient user
                self.db.collection(K.FstoreMessage.collectionName).document(toId).collection(K.FstoreMessage.userMessage).document(fromId).setData([messageId : 1],merge: true)
                
            }
        }
        
        
    }
    
    //MARK: - textfield delgate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleSend()
        return true
    }
}
