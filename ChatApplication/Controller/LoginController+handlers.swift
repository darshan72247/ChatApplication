//
//  LoginController+handlers.swift
//  ChatApplication
//
//  Created by Yash Patel on 2020-06-10.
//  Copyright © 2020 Darshan Patel. All rights reserved.
//

import UIKit
import Firebase

extension LoginController : UIImagePickerControllerDelegate , UINavigationControllerDelegate{
    
    
    //MARK: - handleSelectProfileView ongesture function to add profile image view
    
    @objc func handleSelectProfileView(){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.modalPresentationStyle = .fullScreen
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        //print("cancel ")
        dismiss(animated: true, completion: nil)
    }
    

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        guard let image = info[.originalImage] else {return}
//        //print(image)
        
        var selectedImageFromPicker:UIImage?
        
        if let editedImage = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerReferenceURL")] as? UIImage{
            selectedImageFromPicker = editedImage
        }else if let originalImage = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerOriginalImage")] as? UIImage?{
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker{
            profileImageView.image = selectedImage
        }
        
        dismiss(animated: true, completion: nil)
//        print("hello")
//        print(info)
    }
    //MARK: - handleLogin register button onclick function and its sub part of register and login sub function
    // func for register button
    func handleRegister(){
        
        guard let email = emailTextField.text , let password = passwordTextField.text ,let name = nameTextField.text  else { fatalError("email or password value is null")
        }
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            
            if error != nil{
                print("error")
                return
            }
            
            //MARK: - saving data into cloud Storage
            
            guard let uid = Auth.auth().currentUser?.uid else {
                fatalError("Uid is still yet not generated")}
            let imageName = NSUUID().uuidString
            let storageRef = self.storage.reference().child("profile_images").child("\(imageName).jpg")
            guard let profileImage = self.profileImageView.image else { return }
            if let uploadData = profileImage.jpegData(compressionQuality: 0.1){
                storageRef.putData(uploadData, metadata: nil) { (metadata, error) in
                    if error != nil{
                        print(error!)
                    } else {
                        storageRef.downloadURL { (url, error) in
                            if error != nil{
                                print(error!)
                            } else {
                                //print("Url Downloaded")
                                guard let imageUrl = url?.absoluteString else {return}
                                let values = [ K.FStore.nameField:name ,K.FStore.emailField:email ,K.FStore.profileUrl: imageUrl] as [String : Any]
                                self.registerUserIntoDatabaseWithUID(uid: uid, values: values)
                                
                            }
                        }
                        
                    }
                }
                
            }
        }
    }
    
    private func registerUserIntoDatabaseWithUID(uid: String , values:[String:Any]){
        self.db.collection(K.FStore.collectionName).document(uid).setData(values, completion: { (error) in
            if let e = error
            {
                print("there was an issue regarding saving data to firestore ,\(e) " )
            }
            else
            {
                print("succesfully saved data")
                //self.messagesController?.fetchUserAndSetupnavBarTitle()
                //self.messagesController?.navigationItem.title = values[K.FStore.nameField] as? String
                self.messagesController?.setupNavBarWithUser(data: values)
                self.dismiss(animated: true, completion: nil)
            }
        })
    }
    
    @objc func handleLoginRegister(){
        if loginRegisterSegmentedControl.selectedSegmentIndex == 0 {
            handleLogin()
        }else {
            handleRegister()
        }
    }
    
    func handleLogin(){
        
        
        guard let email = emailTextField.text , let password = passwordTextField.text  else { fatalError("email or password value is null") }
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error != nil {
                print(error!.localizedDescription)
                
                
                let errorString : String = error!.localizedDescription
                if errorString == "There is no user record corresponding to this identifier. The user may have been deleted."{
                    //alert show the user id is invalid and clear the e-mail and password textfield
                    let alert = UIAlertController(title: "Invalid E-mail OR No such user exsist", message: "", preferredStyle: .alert)
                    let action = UIAlertAction(title: "OK", style: .default) { (action) in
                        self.emailTextField.text = ""
                        self.passwordTextField.text = ""
                    }
                    alert.addAction(action)
                    self.present(alert,animated: true,completion: nil)
                } else if errorString == "The password is invalid or the user does not have a password."{
                    //alert show password is invalid and clear the password text field box
                    let alert = UIAlertController(title: "Invalid Password", message: "", preferredStyle:.alert)
                    let action = UIAlertAction(title: "Re-attempt", style: .default) { (action) in
                        self.passwordTextField.text = ""
                    }
                    alert.addAction(action)
                    self.present(alert,animated: true,completion: nil)
                } else if errorString == "The email address is badly formatted."{
                    //alert show email is invalid and clear the password text field box
                    let alert = UIAlertController(title: "Invalid E-mail", message: "", preferredStyle:.alert)
                    let action = UIAlertAction(title: "Re-attempt", style: .default) { (action) in
                        self.emailTextField.text = ""
                    }
                    alert.addAction(action)
                    self.present(alert,animated: true,completion: nil)
                }
                
            } else {
                // succesufully loged in with email and password
//                let activityView = UIActivityIndicatorView(style: .large)
//                activityView.center = self.view.center
//                activityView.startAnimating()
//                self.view.addSubview(activityView)
                
                
//                //set image of laoding
//                let loadingImage = UIImageView()
//                loadingImage.image = UIImage(named: "loading")
//                loadingImage.translatesAutoresizingMaskIntoConstraints = false
//                loadingImage.layer.cornerRadius = 20
//                loadingImage.layer.masksToBounds = true
//                self.view.addSubview(loadingImage)
//
//
//
//                loadingImage.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
//                loadingImage.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
//                loadingImage.heightAnchor.constraint(equalToConstant: 200).isActive = true
//                loadingImage.widthAnchor.constraint(equalToConstant: 200).isActive = true
//

                // loading bar
                let loadingBar = UIProgressView(progressViewStyle: .default)
                loadingBar.translatesAutoresizingMaskIntoConstraints = false
                loadingBar.progress = 0
                loadingBar.setProgress(0, animated: false)
                loadingBar.setProgress(1, animated: true)
                self.view.addSubview(loadingBar)
                
                //x,y,w,h
                loadingBar.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
                loadingBar.topAnchor.constraint(equalTo: self.loginRegisterButton.bottomAnchor,constant: 20).isActive = true
                loadingBar.widthAnchor.constraint(equalToConstant: 350).isActive = true
                loadingBar.heightAnchor.constraint(equalToConstant: 3).isActive = true
                
                
                
                _ = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.handleLoginWithLoading), userInfo: nil, repeats: false)
            }
        }
    }
    
    //MARK: - loading timer after login screen
    @ objc func handleLoginWithLoading(){
        self.messagesController?.fetchUserAndSetupnavBarTitle()
        self.dismiss(animated: true, completion: nil)
    }
    
}
