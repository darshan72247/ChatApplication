//
//  UserCell.swift
//  ChatApplication
//
//  Created by Yash Patel on 2020-06-18.
//  Copyright © 2020 Darshan Patel. All rights reserved.
//

import UIKit
import Firebase

//MARK: - personalized .subtitle cell declare

 // Note :- use this class as a constructor to create a new cell with a type subtitle

class UserCell : UITableViewCell{
    
    // data declared
    let db = Firestore.firestore()
    
    var messages : Message?{
        didSet{
                   setupNameAndProfileImage()
            //        cell.textLabel?.text = messages[indexPath.row].formId
            detailTextLabel?.text = messages?.text
            if let second = messages?.timestamp?.doubleValue{
                let timestampDate = NSDate(timeIntervalSince1970: second)
                
                let dateFormatter = DateFormatter()
                dateFormatter.setLocalizedDateFormatFromTemplate("hh:mm:ss a")
                timeLabel.text = dateFormatter.string(from: timestampDate as Date)
            }
            
        }
    }
    private func setupNameAndProfileImage(){
        
        
        
        
        if let id = messages?.chatPartnerId(){
            db.collection(K.FStore.collectionName).document(id).getDocument { (snapshot, error) in
                if error != nil {
                    print(error!.localizedDescription)
                    return
                } else {
                    let data = snapshot?.data()
                    guard let name = data?[K.FStore.nameField] as? String else {return}
                    self.textLabel?.text = name
                    if let profileImageUrl = data?[K.FStore.profileUrl] as? String{
                        self.profileImageView.loadImageUsingCacheWithUrlString(urlString: profileImageUrl)
                    }
                }
            }
            
        }
    }
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
    
    let timeLabel : UILabel = {
       let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor.darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier : reuseIdentifier)
        addSubview(profileImageView)
        addSubview(timeLabel)
        
        //ios 13 constraints
        //x,y,width & height anchor
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 48).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        //constraint for timelabel
        //x,y,width & height anchor
        timeLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        timeLabel.topAnchor.constraint(equalTo: self.topAnchor,constant: 18).isActive = true
        timeLabel.widthAnchor.constraint(equalToConstant:120 ).isActive = true
        timeLabel.heightAnchor.constraint(equalTo: textLabel!.heightAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
