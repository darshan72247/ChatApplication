//
//  ViewController.swift
//  ChatApplication
//
//  Created by Yash Patel on 2020-06-06.
//  Copyright © 2020 Darshan Patel. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "logout", style: .plain, target: self, action: #selector(handleLogout))
        view.backgroundColor = .white
    }

    @objc func handleLogout(){
        let loginController = LoginController()
        loginController.modalPresentationStyle = .fullScreen   // code for fullscrean view 
        present(loginController,animated:true,completion: nil)
    }
}

extension UIColor {
    convenience init(r: CGFloat , g : CGFloat , b : CGFloat ){
    self.init(red:r/255,green:g/255,blue:b/255,alpha:1)
    }
}
