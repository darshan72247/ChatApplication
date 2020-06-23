//
//  NewMessageController.swift
//  ChatApplication
//
//  Created by Yash Patel on 2020-06-08.
//  Copyright © 2020 Darshan Patel. All rights reserved.
//

import UIKit
import Firebase

class NewMessageController: UITableViewController {

    let db = Firestore.firestore()
    
    // storge declared
    let storage = Storage.storage()
    
    var users = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancel))
        
        tableView.register(UserCell.self, forCellReuseIdentifier: K.newMessageCellIdentifier)
        
        fetchUser()
    }

    @objc func handleCancel(){
        dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //making cell
        //replaces below line with making a class and override the init 
        //let cell = UITableViewCell(style: .subtitle, reuseIdentifier: K.newMessageCellIdentifier)
        let cell = tableView.dequeueReusableCell(withIdentifier: K.newMessageCellIdentifier, for: indexPath) as! UserCell
        let user = users[indexPath.row]
        cell.textLabel?.text = user.name
        cell.detailTextLabel?.text = user.email
        //downloading image from firestorage
        
        if let profileUrl = user.profileImageURL{
            cell.profileImageView.loadImageUsingCacheWithUrlString(urlString: profileUrl)
        }
        
        return cell
    }
    
    func fetchUser(){
        
        db.collection(K.FStore.collectionName).getDocuments { (snapshot, error) in
            if error != nil{
                print(error!)
                return
            } else {
                if let snapshotDocuments = snapshot?.documents
                {
                    for doc in snapshotDocuments {
                        let data = doc.data()
                        
                        let user = User(dictionary: data)
                        user.id = doc.documentID
                            self.users.append(user)
                            
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
//                        }
                    }
                }
                
            }
        }
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    var messageController : MessagesController?
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismiss(animated: true) {
            let user = self.users[indexPath.row]
            print("dismiss controlled")
            self.messageController?.showChatControllerForUser(user: user)
            
        }
    }
}

