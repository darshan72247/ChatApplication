//
//  ChatMessageCell.swift
//  ChatApplication
//
//  Created by Yash Patel on 2020-06-22.
//  Copyright © 2020 Darshan Patel. All rights reserved.
//

import UIKit

class ChatMessageCell: UICollectionViewCell {
    
    let textView : UITextView = {
        let tv = UITextView()
        tv.text = "Sample text"
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = UIColor.clear
        tv.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        tv.isUserInteractionEnabled = false
        tv.font = UIFont.systemFont(ofSize: 16)
        
        return tv
    }()
    
    static let blueColor = UIColor(r: 0, g: 137, b: 249)
    let bubbleView : UIView = {
        let view = UIView()
        view.backgroundColor = blueColor
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        return view
    }()
    
    
    let profileImageView : UIImageView = {
       let imageView = UIImageView()
        imageView.image = UIImage(named: "logo")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 16
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    var bubbleWidthAnchor : NSLayoutConstraint?
    var bubbleViewRightAnchor : NSLayoutConstraint?
    var bubbleViewLeftAnchor : NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        //backgroundColor = #colorLiteral(red: 0.6625987887, green: 0, blue: 0.08400998265, alpha: 1)
        
        addSubview(bubbleView)
        addSubview(textView)
        addSubview(profileImageView)
        
        //x,y,w,h constraints bubble view
        
        bubbleViewRightAnchor = bubbleView.rightAnchor.constraint(equalTo: self.rightAnchor,constant: -8)
        bubbleViewRightAnchor?.isActive = true
        bubbleViewLeftAnchor = bubbleView.leftAnchor.constraint(equalTo: profileImageView.rightAnchor,constant: 8)
        bubbleViewLeftAnchor?.isActive = false
        
        bubbleView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        bubbleWidthAnchor = bubbleView.widthAnchor.constraint(equalToConstant: 200)
        bubbleWidthAnchor?.isActive = true
        bubbleView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        
        //x,y,w,h constraints textview
        textView.leftAnchor.constraint(equalTo: bubbleView.leftAnchor,constant: 8).isActive = true
        textView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        textView.rightAnchor.constraint(equalTo: bubbleView.rightAnchor).isActive = true 
        textView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        //x,y,w,h constraints for profileimage view
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor,constant: 8).isActive = true
        profileImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 32).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 32).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
