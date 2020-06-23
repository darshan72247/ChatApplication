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
        tv.font = UIFont.systemFont(ofSize: 16)
        
        return tv
    }()
    
    let bubbleView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 0, g: 137, b: 249)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        return view
    }()
    
    var bubbleWidthAnchor : NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        //backgroundColor = #colorLiteral(red: 0.6625987887, green: 0, blue: 0.08400998265, alpha: 1)
        
        addSubview(bubbleView)
        addSubview(textView)
        
        //x,y,w,h constraints bubble view
        bubbleView.rightAnchor.constraint(equalTo: self.rightAnchor,constant: -8).isActive = true
        bubbleView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        
        bubbleWidthAnchor = bubbleView.widthAnchor.constraint(equalToConstant: 200)
        bubbleWidthAnchor?.isActive = true
        bubbleView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        //x,y,w,h constraints
        textView.leftAnchor.constraint(equalTo: bubbleView.leftAnchor,constant: 8).isActive = true
        textView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        textView.rightAnchor.constraint(equalTo: bubbleView.rightAnchor).isActive = true 
        textView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
