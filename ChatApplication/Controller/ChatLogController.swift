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
                        
                        self.messages.removeAll()
                        
                        messagesRef.addSnapshotListener { (snapshot, error) in
                            if error != nil {
                                print(error!.localizedDescription)
                                return
                            }
                            if let data = snapshot?.data(){
                                //print(data)
                                let message = Message(dictionary: data)
                                //print(message)
                                print("We fetch a message from the firebase and we need to decide whether or not to filter out :- ",message.text)
                                if message.chatPartnerId() == self.user?.id{
                                    self.messages.append(message)
                                    self.messages.sort { (m1, m2) -> Bool in
                                        m1.timestamp!.intValue < m2.timestamp!.intValue
                                    }
                                    //print(self.messages)
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
        collectionView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
//        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        collectionView.register(ChatMessageCell.self, forCellWithReuseIdentifier: K.newMessageCellIdentifier)
        collectionView.alwaysBounceVertical = true
        
        collectionView.keyboardDismissMode = .interactive
        
//        setupInputComponents()
//        setupKeyboardObservers()
    }
    
    lazy var inputContainerView : UIView = {
        let containerView = UIView()
        containerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50)
        containerView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        
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
        
        
        
        
        return containerView
    }()
    
    override var inputAccessoryView: UIView? {
        get{
            return inputContainerView
        }
    }
    
    override var canBecomeFirstResponder: Bool{
        return true
    }
    
    
    
//    func setupKeyboardObservers(){
//        NotificationCenter.default.addObserver(self,selector:#selector(handleKeyboardWillShow),name:UIResponder.keyboardWillShowNotification,object : nil)
//
//        NotificationCenter.default.addObserver(self,selector:#selector(handleKeyboardWillHide),name:UIResponder.keyboardWillHideNotification,object : nil)
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewDidDisappear(animated)
//        NotificationCenter.default.removeObserver(self)
//    }
//
//    @objc func handleKeyboardWillShow(notification : NSNotification){
//
//        if let keyboardSize = notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue
//            , let keyboardDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
//         {
//
//            // move the text label up somehow ??
//            let keyboardHeight = keyboardSize.cgRectValue.height
//            print(keyboardSize.cgRectValue.height)
//            containerViewBottomAnchor?.constant = -(keyboardHeight)
//            UIView.animate(withDuration: (keyboardDuration)) { self.view.layoutIfNeeded() }
//        }
//    }
//
//    @objc func handleKeyboardWillHide(notification : Notification){
//
//            containerViewBottomAnchor?.constant = 0
//
////        if  let keyboardDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double,
////            {
////
////            containerViewBottomAnchor?.constant = 0
////            UIView.animate(withDuration: (keyboardDuration)) {
////                self.view.layoutIfNeeded()
////            }
////        }
//
//    }
    
    
    
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
        
        setupCell(cell: cell, message: message )
        
        
        cell.bubbleWidthAnchor?.constant = estimateFrameForText(text: message.text!).width + 32
        
        
        return cell
    }
    
    private func setupCell(cell:ChatMessageCell , message:Message){
        if let profileImageUrl = self.user?.profileImageURL{
            cell.profileImageView.loadImageUsingCacheWithUrlString(urlString: profileImageUrl)
        }
        if message.fromId == Auth.auth().currentUser?.uid{
            //outgoing blue
            cell.bubbleView.backgroundColor = ChatMessageCell.blueColor
            cell.textView.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            cell.profileImageView.isHidden = true
            
            cell.bubbleViewRightAnchor?.isActive = true
            cell.bubbleViewLeftAnchor?.isActive = false
        } else {
            //incoming grey
            cell.bubbleView.backgroundColor = UIColor(r: 240, g: 240, b: 240)
            cell.textView.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            cell.profileImageView.isHidden = false
            cell.bubbleViewRightAnchor?.isActive = false
            cell.bubbleViewLeftAnchor?.isActive = true
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height:CGFloat = 80
        
        if let text = messages[indexPath.row].text{
            height = estimateFrameForText(text: text).height + 20
        }
        
        return CGSize(width: collectionView.frame.width, height: height)
    }
    
    private func estimateFrameForText(text : String) -> CGRect{
        let size = CGSize(width: 200, height: 1000)
        
        let option = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        
        
        return NSString(string: text).boundingRect(with: size, options: option, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16)], context: nil)
    }
    
    
    //MARK: - container box constraints
    var containerViewBottomAnchor : NSLayoutConstraint?
    
    func setupInputComponents(){
        let containerView = UIView()
        containerView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0) 
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(containerView)
        
        // constraints for container view of new message box
        //x,y,w,h
        containerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        
        containerViewBottomAnchor = containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        containerViewBottomAnchor?.isActive = true
        
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
                self.db.collection(K.FstoreMessage.collectionName).document(fromId).collection(K.FstoreMessage.userMessage).document(toId).setData([messageId : timestamp], merge: true)
                
                // saving data for recipient user
                self.db.collection(K.FstoreMessage.collectionName).document(toId).collection(K.FstoreMessage.userMessage).document(fromId).setData([messageId : timestamp],merge: true)
                
            }
        }
        
        
    }
    
    //MARK: - textfield delgate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleSend()
        return true
    }
}
