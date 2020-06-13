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
                        if let name = data[K.FStore.nameField] as? String ,let email = data[K.FStore.emailField] as? String , let profileImageurl = data[K.FStore.profileUrl] as? String{
                            let user = User(username: name, useremail: email , profileImageUrl: profileImageurl)
                            self.users.append(user)
                            
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                        }
                    }
                }
                
            }
        }
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
}


//MARK: - personalized .subtitle cell declare

 // Note :- use this class as a constructor to create a new cell with a type subtitle 

class UserCell : UITableViewCell{
    
    override func layoutSubviews() {
        super.layoutSubviews()
        textLabel?.frame = CGRect(x: 64, y: textLabel!.frame.origin.y-2, width: textLabel!.frame.width, height: textLabel!.frame.height)
        detailTextLabel?.frame = CGRect(x: 64, y: detailTextLabel!.frame.origin.y+2, width: detailTextLabel!.frame.width, height: detailTextLabel!.frame.height)
    }
    
    
    let profileImageView: UIImageView = {
     let imageview = UIImageView()
        imageview.translatesAutoresizingMaskIntoConstraints = false
        imageview.layer.cornerRadius = 24
        imageview.layer.masksToBounds = true
        imageview.contentMode = .scaleAspectFit
     return imageview
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier : reuseIdentifier)
        addSubview(profileImageView)
        
        //ios 13 constraints
        //x,y,width & height anchor
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 48).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 48).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
