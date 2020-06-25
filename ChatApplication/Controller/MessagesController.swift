//
//  ViewController.swift
//  ChatApplication
//
//  Created by Yash Patel on 2020-06-06.
//  Copyright © 2020 Darshan Patel. All rights reserved.
//

import UIKit
import Firebase

class MessagesController: UITableViewController {

        // data declared
        let db = Firestore.firestore()
    
    var messages = [Message]()
    var messagesDictionary = [String:Message]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "logout", style: .plain, target: self, action: #selector(handleLogout))
        view.backgroundColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(handleNewMessage))
        
        tableView.register(UserCell.self, forCellReuseIdentifier: K.newMessageCellIdentifier)
        checkIfUserIsLoggedIn()
        
        
    }
    var timer: Timer?
    func observeUserMessages()
    {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let ref = db.collection(K.FstoreMessage.collectionName).document(uid).collection(K.FstoreMessage.userMessage)
        ref.addSnapshotListener { (querySnapshot, error) in
            if error != nil {
                print(error!.localizedDescription)
                return
            }
            if let querySnapshot = querySnapshot?.documents{
                for snapshot in querySnapshot{
                    let data = snapshot.data()
                    //print(data.keys)
                    for elements in data{
                        let messageId = elements.key
                        self.fetchMessageWithMessageId(with: messageId)
                    }
                }
            }
        }
    }
    
    
    //MARK: - fetch message for specific user
    private func fetchMessageWithMessageId(with messageId : String){
        let messagesRef = self.db.collection(K.FstoreMessage.collectionName).document(messageId)
        messagesRef.addSnapshotListener { (snapshot1, error) in
            if error != nil {
                print(error!.localizedDescription)
                return
            }
            //print(snapshot1?.data())
            print("data obsereve to load mainscreen")
            if let messageData = snapshot1?.data(){
                let message = Message(dictionary: messageData)
                
                if let chatPartnerId  = message.chatPartnerId(){
                    self.messagesDictionary[chatPartnerId] = message
                }
                   
                
                self.attemptReloadOfTable()
                

            }
        }
    }
    
    //MARK: - reload table and save memmory leak
    
    private func attemptReloadOfTable(){
        self.messages = Array(self.messagesDictionary.values)
        
        //sorting chat as per time thety were sent
        self.messages.sort { (message1, message2) -> Bool in
            return message1.timestamp!.intValue > message2.timestamp!.intValue
        }
        
        self.timer?.invalidate()
        //we  just canccled our timer
        self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.handleTimer), userInfo: nil, repeats: false)
        // schelude a table reload in 0.1 sec
    }
    
    @objc func handleTimer (){
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func checkIfUserIsLoggedIn()
    {
        if  Auth.auth().currentUser?.uid == nil{
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        } else {
            
           fetchUserAndSetupnavBarTitle()
        }
    }
    
    func fetchUserAndSetupnavBarTitle(){
        guard let uid = Auth.auth().currentUser?.uid else {return}
                   db.collection(K.FStore.collectionName).getDocuments() { (snapshot, err) in
                       if let err = err {
                           print("Error getting documents: \(err)")
                       } else {
                           for doc in snapshot!.documents {
                               let data = doc.data()
                               if  uid == doc.documentID{
                                self.setupNavBarWithUser(data: data)
                                   //self.navigationItem.title = data[K.FStore.nameField] as? String
                               }
                           }
                       }
                   }
    }
    
    func setupNavBarWithUser(data : [String : Any]){
        messages.removeAll()
        messagesDictionary.removeAll()
        tableView.reloadData()
        observeUserMessages()
        
        let titleView = UIView()
        titleView.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        //titleView.backgroundColor = UIColor.red

        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(titleView)

        containerView.centerXAnchor.constraint(equalTo: titleView.centerXAnchor).isActive = true
        containerView.centerYAnchor.constraint(equalTo: titleView.centerYAnchor).isActive = true
        //containerView.backgroundColor = UIColor.yellow

        let profileImageView = UIImageView()
        if let profileImageUrl = data[K.FStore.profileUrl] as? String{
            profileImageView.loadImageUsingCacheWithUrlString(urlString: profileImageUrl)
            profileImageView.contentMode = .scaleAspectFill
            profileImageView.layer.cornerRadius = 20
            profileImageView.clipsToBounds = true
            profileImageView.translatesAutoresizingMaskIntoConstraints = false
        }
        titleView.addSubview(profileImageView)
        //ios13 constraints
        //x,y,height,width constraints
        profileImageView.leftAnchor.constraint(equalTo: titleView.leftAnchor).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true

        let namelabel = UILabel()
        titleView.addSubview(namelabel)
        guard let name = data[K.FStore.nameField] as? String else { return }
        namelabel.text = name
        namelabel.translatesAutoresizingMaskIntoConstraints = false

        namelabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8).isActive = true
        namelabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor).isActive = true
        namelabel.rightAnchor.constraint(equalTo: titleView.rightAnchor).isActive = true
        namelabel.heightAnchor.constraint(equalTo: profileImageView.heightAnchor).isActive = true


        self.navigationItem.titleView = titleView
        //titleView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showChatController)))
    
        
        
    }
    
    @objc func showChatControllerForUser(user : User){
        let chatLogController = ChatLogController(collectionViewLayout: UICollectionViewFlowLayout())
        chatLogController.user = user
        navigationController?.pushViewController(chatLogController, animated: true)
    }

    @objc func handleLogout(){
        
        do{
            try Auth.auth().signOut()
        } catch let logouterror {
            print(logouterror)
        }
        
        let loginController = LoginController()
        loginController.messagesController = self
        loginController.modalPresentationStyle = .fullScreen // code for fullscrean view
        present(loginController,animated:true,completion: nil)
    }
    
    //MARK: - add button in navigation bar onclick function
    @objc func handleNewMessage(){
        let newMessageViewController = NewMessageController()
        newMessageViewController.messageController = self
//        newMessageViewController.modalPresentationStyle = .overFullScreen  // code for fullscrean view
        //navigationController?.pushViewController(newMessageViewController, animated: true)
        let nc = UINavigationController(rootViewController: newMessageViewController)
        nc.modalPresentationStyle = .fullScreen
        present(nc,animated : true , completion:nil)
    }
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.newMessageCellIdentifier, for: indexPath) as! UserCell
        
        let message = messages[indexPath.row]
        cell.messages = message
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let message = messages[indexPath.row]
//        print(message.text)
        guard let chatPartnerId = message.chatPartnerId() else {
            return
        }
        let ref = db.collection(K.FStore.collectionName).document(chatPartnerId)
        ref.addSnapshotListener { (snapshot, error) in
            if error != nil {
                print(error!.localizedDescription)
                return
            }
            if let data = snapshot?.data(){
                print(data)
                let user = User(dictionary: data)
                user.id = chatPartnerId
                self.showChatControllerForUser(user: user)
                
            }
        }

    }
}


extension UIColor {
    convenience init(r: CGFloat , g : CGFloat , b : CGFloat ){
    self.init(red:r/255,green:g/255,blue:b/255,alpha:1)
    }
}
