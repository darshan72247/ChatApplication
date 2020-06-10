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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "logout", style: .plain, target: self, action: #selector(handleLogout))
        view.backgroundColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(handleNewMessage))
        
        checkIfUserIsLoggedIn()
        
    }
    
    func checkIfUserIsLoggedIn()
    {
        if  Auth.auth().currentUser?.uid == nil{
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        } else {
            
            let uid = Auth.auth().currentUser?.uid
            db.collection(K.FStore.collectionName).getDocuments() { (snapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for doc in snapshot!.documents {
                        let data = doc.data()
                        if  uid == doc.documentID{
                            self.navigationItem.title = data[K.FStore.nameField] as? String
                        }
                    }
                }
            }
        }
    }

    @objc func handleLogout(){
        
        do{
            try Auth.auth().signOut()
        } catch let logouterror {
            print(logouterror)
        }
        
        let loginController = LoginController()
        loginController.modalPresentationStyle = .fullScreen // code for fullscrean view
        present(loginController,animated:true,completion: nil)
    }
    
    //MARK: - add button in navigation bar onclick function
    @objc func handleNewMessage(){
        let newMessageViewController = NewMessageController()
//        newMessageViewController.modalPresentationStyle = .overFullScreen  // code for fullscrean view
        //navigationController?.pushViewController(newMessageViewController, animated: true)
        let nc = UINavigationController(rootViewController: newMessageViewController)
        nc.modalPresentationStyle = .fullScreen
        present(nc,animated : true , completion:nil)
    }
}

extension UIColor {
    convenience init(r: CGFloat , g : CGFloat , b : CGFloat ){
    self.init(red:r/255,green:g/255,blue:b/255,alpha:1)
    }
}
