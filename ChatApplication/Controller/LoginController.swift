  //
//  Login Controller.swift
//  ChatApplication
//
//  Created by Yash Patel on 2020-06-06.
//  Copyright © 2020 Darshan Patel. All rights reserved.
//

import UIKit
import Firebase

class LoginController: UIViewController {
    
    // data declared
    let db = Firestore.firestore()
    
    //MARK: - main login box closure
    let inputContainerView:  UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.05490196078, green: 0.6039215686, blue: 0.6549019608, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        return view
    }()
    //MARK: - register button closure
    
    lazy var loginRegiterButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Register", for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.9647058824, green: 0.8039215686, blue: 0.3803921569, alpha: 1)
        button.layer.cornerRadius = 17
        button.setTitleColor(#colorLiteral(red: 0.395519495, green: 0.2288445532, blue: 1, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleLoginRegister), for: .touchUpInside)
        return button
    }()
    

    //MARK: - name line separtor
    
    let nameSeparatorView : UIView = {
       let view = UIView()
        view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //MARK: - Name textfield
    
    let nameTextField: UITextField = {
       let tf = UITextField()
        tf.attributedPlaceholder = NSAttributedString(string: "Name", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        tf.layer.cornerRadius = 15
        tf.translatesAutoresizingMaskIntoConstraints = false
       return tf
    }()
    
    //MARK: - email line separtor
    
    let emailSeparatorView : UIView = {
       let view = UIView()
        view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //MARK: - email textfield
    
    let emailTextField: UITextField = {
       let tf = UITextField()
        tf.attributedPlaceholder = NSAttributedString(string: "Email-Id", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        tf.layer.cornerRadius = 15
        tf.translatesAutoresizingMaskIntoConstraints = false
       return tf
    }()

    //MARK: - password textfield
    
    let passwordTextField: UITextField = {
       let tf = UITextField()
        tf.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        tf.layer.cornerRadius = 15
        tf.isSecureTextEntry = true
        tf.translatesAutoresizingMaskIntoConstraints = false
       return tf
    }()
    
    //MARK: - Login Image
    let profileImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "logo")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    //MARK: - login and register toggle button
    let loginRegisterSegmentedControl : UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Login", "Register"])
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.selectedSegmentIndex = 1
        sc.addTarget(self, action: #selector(handleLoginRegisterChange), for: .valueChanged)
        return sc
    }()
    
   
    
    //MARK: - view did load
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        // Do any additional setup after loading the view.
        
        view.addSubview(inputContainerView)
        view.addSubview(loginRegiterButton)
        view.addSubview(profileImageView)
        view.addSubview(loginRegisterSegmentedControl)
        
        setupInputsContainer()
        setupLoginRegisterButton()
        setupProfileImageView()
        setuploginRegisterSegmentedControl()
    }
    
    
    //MARK: - constrains for login box
    
    var inputsConatinerViewHeightAnchor : NSLayoutConstraint?
    
    var nameTextFieldHeightAnchor : NSLayoutConstraint?
    
    var emailTextFieldHeightAnchor : NSLayoutConstraint?
    
    var passwordTextFieldHeightAnchor : NSLayoutConstraint?
    
    func setupInputsContainer(){
        // need x , y , width , height constraints
        inputContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        inputContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        inputsConatinerViewHeightAnchor = inputContainerView.heightAnchor.constraint(equalToConstant: 150)
        inputsConatinerViewHeightAnchor?.isActive = true
        
        
       
        
        //MARK: - name constraints
        inputContainerView.addSubview(nameTextField)
        // need x , y , width , height constraints
        nameTextField.leftAnchor.constraint(equalTo:inputContainerView.leftAnchor , constant: 12).isActive = true
        nameTextField.topAnchor.constraint(equalTo: inputContainerView.topAnchor).isActive = true
        nameTextField.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor , multiplier: 1/3)
        nameTextFieldHeightAnchor?.isActive = true
        
        
        //MARK: - line separator constraints for name and email
        inputContainerView.addSubview(nameSeparatorView )
        // need x , y , width , height constraints
        nameSeparatorView.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor).isActive = true
        nameSeparatorView.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        nameSeparatorView.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        nameSeparatorView.heightAnchor.constraint(equalToConstant: 2).isActive = true
        
        //MARK: - email constraints
        inputContainerView.addSubview(emailTextField)
        // need x , y , width , height constraints
        emailTextField.leftAnchor.constraint(equalTo:inputContainerView.leftAnchor , constant: 12).isActive = true
        emailTextField.topAnchor.constraint(equalTo: nameSeparatorView.topAnchor).isActive = true
        emailTextField.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor , multiplier: 1/3)
        emailTextFieldHeightAnchor?.isActive = true
        
        //MARK: - line separator constraints for email and password
        inputContainerView.addSubview(emailSeparatorView)
        // need x , y , width , height constraints
        emailSeparatorView.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor).isActive = true
        emailSeparatorView.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        emailSeparatorView.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        emailSeparatorView.heightAnchor.constraint(equalToConstant: 2).isActive = true
        
        //MARK: - password constraints
        inputContainerView.addSubview(passwordTextField)
        // need x , y , width , height constraints
        passwordTextField.leftAnchor.constraint(equalTo:inputContainerView.leftAnchor , constant: 12).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: emailSeparatorView.topAnchor).isActive = true
        passwordTextField.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        passwordTextFieldHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor , multiplier: 1/3)
        passwordTextFieldHeightAnchor?.isActive = true
        
        
        
    }
    //MARK: - login buttton constraints
    func setupLoginRegisterButton(){
        // need x , y , width , height constraints
        loginRegiterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegiterButton.topAnchor.constraint(equalTo: inputContainerView.bottomAnchor, constant: 12 ).isActive = true
        loginRegiterButton.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        loginRegiterButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
    }
    
    //MARK: - profile image constraints
    func setupProfileImageView(){
        // need x , y , width , height constraints
        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImageView.bottomAnchor.constraint(equalTo: loginRegisterSegmentedControl.topAnchor,constant: -12).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 250).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 250).isActive = true
        
    }
    
    //MARK: - handleLogin register button onclick function and its sub part of register and login sub function
    // func for register button
    func handleRegister(){
        guard let email = emailTextField.text , let password = passwordTextField.text ,let name = nameTextField.text else { fatalError("email or password value is null")
        }
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            
            if error != nil{
                print("error")
                return
            }
            
           //MARK: - saving data into cloud Storage
            self.db.collection(K.FStore.collectionName).addDocument(data: [
                K.FStore.nameField:name ,
                K.FStore.emailField:email ])
            { (error) in
                if let e = error
                {
                    print("there was an issue regarding saving data to firestore ,\(e) " )
                }
                else
                {
                    print("succesfully saved data")
                    self.dismiss(animated: true, completion: nil)
                }
            }
            
        }
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
                print(error!)
            } else {
                // succesufully loged in with email and password
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    //MARK: - loginRegisterSegmentControl constraints
    func setuploginRegisterSegmentedControl(){
         // need x , y , width , height constraints
        loginRegisterSegmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterSegmentedControl.bottomAnchor.constraint(equalTo: inputContainerView.topAnchor,constant: -12).isActive = true
        loginRegisterSegmentedControl.widthAnchor.constraint(equalTo: view.widthAnchor , constant: -24).isActive = true
        loginRegisterSegmentedControl.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    //MARK: - selector for login and register value changed
    
    @objc func handleLoginRegisterChange(){
        let title = loginRegisterSegmentedControl.titleForSegment(at: loginRegisterSegmentedControl.selectedSegmentIndex)
        loginRegiterButton.setTitle(title, for: .normal)
        
        // change the height of inpitcontainer view but how ??
        inputsConatinerViewHeightAnchor?.constant = loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 100 : 150
        
        // change height of nameTextfield
        
        nameTextFieldHeightAnchor?.isActive = false
        nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 0 : 1/3)
        nameTextFieldHeightAnchor?.isActive = true
        
        // change of email and password as per login or register
        emailTextFieldHeightAnchor?.isActive = false
        emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        emailTextFieldHeightAnchor?.isActive = true
        
        passwordTextFieldHeightAnchor?.isActive = false
        passwordTextFieldHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        passwordTextFieldHeightAnchor?.isActive = true
    }
    
}
