  //
//  Login Controller.swift
//  ChatApplication
//
//  Created by Yash Patel on 2020-06-06.
//  Copyright © 2020 Darshan Patel. All rights reserved.
//

import UIKit
import Firebase

  class LoginController: UIViewController, UITextFieldDelegate {
    
    var messagesController : MessagesController?
    // data declared
    let db = Firestore.firestore()
    // storge declared
    let storage = Storage.storage()
    
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
    
    lazy var loginRegisterButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Register", for: .normal)
//        button.backgroundColor = #colorLiteral(red: 0.9647058824, green: 0.8039215686, blue: 0.3803921569, alpha: 1)
        button.backgroundColor = #colorLiteral(red: 0.9968226552, green: 0.8864033818, blue: 0.4593802691, alpha: 1)
        button.layer.cornerRadius = 17
//        button.setTitleColor(#colorLiteral(red: 0.395519495, green: 0.2288445532, blue: 1, alpha: 1), for: .normal)
        button.setTitleColor(#colorLiteral(red: 0.1131096557, green: 0.6524511576, blue: 0.8918609023, alpha: 1), for: .normal)
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
    lazy var profileImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "logo")
//        imageView.layer.cornerRadius = 45
//        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectProfileView)))
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
        view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
        // Do any additional setup after loading the view.
        
        view.addSubview(inputContainerView)
        view.addSubview(loginRegisterButton)
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
        loginRegisterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterButton.topAnchor.constraint(equalTo: inputContainerView.bottomAnchor, constant: 12 ).isActive = true
        loginRegisterButton.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        loginRegisterButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
    }
    
    //MARK: - profile image constraints
    func setupProfileImageView(){
        // need x , y , width , height constraints
        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImageView.bottomAnchor.constraint(equalTo: loginRegisterSegmentedControl.topAnchor,constant: -24).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
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
        loginRegisterButton.setTitle(title, for: .normal)
        
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
