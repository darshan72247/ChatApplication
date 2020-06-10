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
        let cell = tableView.dequeueReusableCell(withIdentifier: K.newMessageCellIdentifier, for: indexPath)
        let user = users[indexPath.row]
        cell.textLabel!.text = user.name
        cell.detailTextLabel?.text = user.email
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
                        if let name = data[K.FStore.nameField] as? String ,let email = data[K.FStore.emailField] as? String{
                            let user = User(username: name, useremail: email)
                            self.users.append(user)
                            print(user.name , user.email)
                            
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                        }
                    }
                }
                
            }
        }
    }
}


//MARK: - personalized .subtitle cell declare

 // Note :- use this class as a constructor to create a new cell with a type subtitle 

class UserCell : UITableViewCell{
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier : reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
