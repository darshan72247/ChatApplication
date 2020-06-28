//
//  ChatLogController.swift
//  ChatApplication
//
//  Created by Yash Patel on 2020-06-15.
//  Copyright © 2020 Darshan Patel. All rights reserved.
//

import UIKit
import Firebase
import MobileCoreServices
import AVFoundation

class ChatLogController: UICollectionViewController , UITextFieldDelegate , UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    // storge declared
    let storage = Storage.storage()
    
    var user : User?{
        didSet{
            navigationItem.title = user?.name
            
            obsereveMessages()
        }
    }
    
    var messages = [Message]()
    
    func obsereveMessages(){
        
        
        guard let uid = Auth.auth().currentUser?.uid , let toId = user?.id else { return }
        let userMessageRef = db.collection(K.FstoreMessage.collectionName).document(uid).collection("user-messages").document(toId)
        userMessageRef.addSnapshotListener { (snapshot, error) in
            if error != nil {
                print(error!.localizedDescription)
                return
            }
            
            self.messages.removeAll()
            
            if let data = snapshot?.data(){
                //print(data)
                for elements in data{
                    let messageId = elements.key
                    let messagesRef = self.db.collection(K.FstoreMessage.collectionName).document(messageId)
                    
                    messagesRef.addSnapshotListener { (snapshot , error) in
                        if error != nil {
                            print(error!.localizedDescription)
                            return
                        }
                        if let data = snapshot?.data(){
                            let message = Message(dictionary: data)
                            //print(message)
                            //print("We fetch a message from the firebase and we need to decide whether or not to filter out",message.text)
                            self.messages.append(message)
                            self.messages.sort { (m1, m2) -> Bool in
                                m1.timestamp!.intValue < m2.timestamp!.intValue
                            }
                            //print(self.messages)
                            DispatchQueue.main.async {
                                self.collectionView.reloadData()
                                let indexPath = NSIndexPath(item: self.messages.count-1, section: 0)
                                self.collectionView.scrollToItem(at: indexPath as IndexPath, at: .bottom, animated: true)
                            }
                        }
                    }
                    
                }
            }
        }
    }
    
    // data declared
    let db = Firestore.firestore()
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        collectionView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        //        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        collectionView.register(ChatMessageCell.self, forCellWithReuseIdentifier: K.newMessageCellIdentifier)
        collectionView.alwaysBounceVertical = true
        
        collectionView.keyboardDismissMode = .interactive
        
        //        setupInputComponents()
        setupKeyboardObservers()
    }
    
    private func setupKeyboardObservers(){
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self,
                                       selector: #selector(handleKeyboardDidShow),
                                       name: UIResponder.keyboardDidShowNotification,
                                       object: nil)
    }
    
    @objc func handleKeyboardDidShow(){
        if messages.count > 0 {
            let indexPath = NSIndexPath(item: messages.count-1, section: 0)
            collectionView.scrollToItem(at: indexPath as IndexPath, at: .top, animated: true)
        }
    }
    
    
    lazy var inputContainerView : ChatInputContainerView = {
        let chatInputContainerView = ChatInputContainerView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50))
        chatInputContainerView.chatLogController = self
        return chatInputContainerView
        
//        let containerView = UIView()
//        containerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50)
//        containerView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
//        return containerView
    }()
    
    @objc func handleUploadTap(){
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.mediaTypes = [kUTTypeImage as String , kUTTypeMovie as String]
        imagePickerController.allowsEditing = true 
        present(imagePickerController, animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let videoUrl = info[UIImagePickerController.InfoKey.mediaURL] as? URL{
            // we slected a Video
            handleVideoSelectefForUrl(with: videoUrl)
        } else {
            //we selected an image
            handleImageSelectedForInfo(info: info)
        }
        dismiss(animated: true, completion: nil)
    }
    
    private func handleVideoSelectefForUrl(with videoFileUrl : URL){
        //print("here is the file url :- ",videoFileUrl)
        
        let videoName = NSUUID().uuidString + ".mov"
        let videoStorageRef = storage.reference().child("message_movies").child(videoName)
        
        do{
            let data = try Data(contentsOf: videoFileUrl)
            let uploadtask =  videoStorageRef.putData(data, metadata: nil) { (metadata, error) in
                if error != nil {
                    print("failed to upload video :",error!.localizedDescription)
                    return
                }
                videoStorageRef.downloadURL { (url, error) in
                    if error != nil {
                        print("error downloading video url :- ", error!.localizedDescription)
                        return
                    }
                    if let videoUrl = url?.absoluteString{
                        print("Video Url Downloaded")
                        //print(videoUrl)
                        
                        if let thumbnailImage = self.thumbnailImageForFileUrl(fileUrl: videoFileUrl){
                            self.uploadToFirebaseStorageUsingIamge(image: thumbnailImage) { (imageUrl) in
                                
                                let properties = [
                                    K.FstoreMessage.imageUrlField : imageUrl,
                                    K.FstoreMessage.imageWidth : thumbnailImage.size.width ,
                                    K.FstoreMessage.imageHeigt : thumbnailImage.size.height,
                                    K.FstoreMessage.videoUrlField : videoUrl ] as [String : Any]
                                self.sendMessageWithProperties(properties: properties )
                            }
                        }
                    }
                }
            }
            
            
         
            uploadtask.observe(.progress) { (snapshot) in
                
                self.navigationItem.title = "Video Uploading ...."
                
                
                let alert = UIAlertController(title: "Video Uploading", message: "", preferredStyle: .alert)
                
                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                 alert.addAction(action)
                
                self.present(alert, animated: true, completion: nil)
//                                if let progesstime = snapshot.progress {
//                                    //print(Int(progesstime.completedUnitCount)) printing values
//                                    // from above values can show the progess bar
////                                    let loading = UIProgressView(frame: CGRect(x: 30, y: 50, width: 2, height: 5))
////                                    loading.setProgress(Float(progesstime as! Int), animated: true)
//                                }
            }
            uploadtask.observe(.success) { (snapshot) in
                self.navigationItem.title = self.user?.name
                
            }
        } catch {
            print(error)
            return
        }
    }
    
    private func thumbnailImageForFileUrl(fileUrl : URL) -> UIImage?{
        let asset = AVAsset(url: fileUrl)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        do{
            let thumbnailCGImage = try imageGenerator.copyCGImage(at: CMTime(value: 1, timescale: 60), actualTime: nil)
            return UIImage(cgImage: thumbnailCGImage)
        } catch  let error {
            print(error)
        }
        
        return nil
    }
    
    private func handleImageSelectedForInfo(info : [UIImagePickerController.InfoKey : Any]){
        var selectedImageFromPicker:UIImage?
        
        if let editedImage = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerReferenceURL")] as? UIImage{
            selectedImageFromPicker = editedImage
        }else if let originalImage = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerOriginalImage")] as? UIImage?{
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker{
            uploadToFirebaseStorageUsingIamge(image: selectedImage) { (imageUrl) in
                self.sendMessageWithImageUrl(imageUrl: imageUrl, image: selectedImage)
            }
        }
    }
    
    private func uploadToFirebaseStorageUsingIamge(image:UIImage , completion: @escaping (String) -> ()){
        print("upload to firebase ")
        let imageName = NSUUID().uuidString
        let ref = storage.reference().child("messages_images").child(imageName)
        if let uploadData = image.jpegData(compressionQuality: 0.2){
            ref.putData(uploadData, metadata: nil) { (metadata, error) in
                if error != nil {
                    print("failed to upload message image :- ",error!.localizedDescription)
                    return
                }
                
                ref.downloadURL { (url, error) in
                    if error != nil{
                        print(error!)
                    } else {
                        print("Url Downloaded")
                        guard let imageUrl = url?.absoluteString else {return}
                        // print(imageUrl)
                        completion(imageUrl)
                    }
                }
                
            }
        }
    }
    
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
        
    }
    
    override var inputAccessoryView: UIView? {
        get{
            return inputContainerView
        }
    }
    
    override var canBecomeFirstResponder: Bool{
        return true
    }
    
    //send message copied and pated below
    
    
    //    func setupKeyboardObservers(){
    //        NotificationCenter.default.addObserver(self,selector:#selector(handleKeyboardWillShow),name:UIResponder.keyboardWillShowNotification,object : nil)
    //
    //        NotificationCenter.default.addObserver(self,selector:#selector(handleKeyboardWillHide),name:UIResponder.keyboardWillHideNotification,object : nil)
    //    }
    //
    //    override func viewWillDisappear(_ animated: Bool) {
    //        super.viewDidDisappear(animated)
    //        NotificationCenter.default.removeObserver(self)
    //    }
    //
    //    @objc func handleKeyboardWillShow(notification : NSNotification){
    //
    //        if let keyboardSize = notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue
    //            , let keyboardDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
    //         {
    //
    //            // move the text label up somehow ??
    //            let keyboardHeight = keyboardSize.cgRectValue.height
    //            print(keyboardSize.cgRectValue.height)
    //            containerViewBottomAnchor?.constant = -(keyboardHeight)
    //            UIView.animate(withDuration: (keyboardDuration)) { self.view.layoutIfNeeded() }
    //        }
    //    }
    //
    //    @objc func handleKeyboardWillHide(notification : Notification){
    //
    //            containerViewBottomAnchor?.constant = 0
    //
    ////        if  let keyboardDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double,
    ////            {
    ////
    ////            containerViewBottomAnchor?.constant = 0
    ////            UIView.animate(withDuration: (keyboardDuration)) {
    ////                self.view.layoutIfNeeded()
    ////            }
    ////        }
    //
    //    }
    
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.newMessageCellIdentifier, for: indexPath) as! ChatMessageCell
        
        cell.ChatLogController = self
        
        let message = messages[indexPath.row]
        cell.message = message
        cell.textView.text = message.text
        
        setupCell(cell: cell, message: message )
        
        if let text = message.text{
            cell.bubbleWidthAnchor?.constant = estimateFrameForText(text: text).width + 32
            cell.textView.isHidden = false
        } else if message.imageUrl != nil {
            cell.bubbleWidthAnchor?.constant = 200
            cell.textView.isHidden = true
        }
//
//        if message.videoUrl != nil {
//            cell.playButton.isHidden = false
//        } else {
//            cell.playButton.isHidden = true
//        }
         
        cell.playButton.isHidden = message.videoUrl == nil
        
        
        return cell
    }
    
    private func setupCell(cell:ChatMessageCell , message:Message){
        if let profileImageUrl = self.user?.profileImageURL{
            cell.profileImageView.loadImageUsingCacheWithUrlString(urlString: profileImageUrl)
        }
        
        
        if message.fromId == Auth.auth().currentUser?.uid{
            //outgoing blue
            cell.bubbleView.backgroundColor = ChatMessageCell.blueColor
            cell.textView.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            cell.profileImageView.isHidden = true
            
            cell.bubbleViewRightAnchor?.isActive = true
            cell.bubbleViewLeftAnchor?.isActive = false
        } else {
            //incoming grey
            cell.bubbleView.backgroundColor = UIColor(r: 240, g: 240, b: 240)
            cell.textView.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            cell.profileImageView.isHidden = false
            cell.bubbleViewRightAnchor?.isActive = false
            cell.bubbleViewLeftAnchor?.isActive = true
        }
        if let messgeImageUrl = message.imageUrl{
            
            cell.bubbleView.backgroundColor = .clear
            cell.messageImageView.loadImageUsingCacheWithUrlString(urlString: messgeImageUrl)
            cell.messageImageView.isHidden = false
            
        } else {
            cell.messageImageView.isHidden = true
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height:CGFloat = 80
        let message = messages[indexPath.row]
        
        if let text = message.text{
            height = estimateFrameForText(text: text).height + 20
        } else if let imageWidth = message.imageWidth?.floatValue ,
            let imageHeight = message.imageHeight?.floatValue {
            // h1 / w1 = h2 / w2
            //solve for h1
            // h1 = h2 / w2 * w1
            height = CGFloat (imageHeight / imageWidth * 200)
        }
        
        return CGSize(width: collectionView.frame.width, height: height)
    }
    
    private func estimateFrameForText(text : String) -> CGRect{
        let size = CGSize(width: 200, height: 1000)
        
        let option = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        
        
        return NSString(string: text).boundingRect(with: size, options: option, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16)], context: nil)
    }
    
    
    //MARK: - container box constraints
    var containerViewBottomAnchor : NSLayoutConstraint?
    
    //MARK: - send button clicked function
    @objc func handleSend(){
        
        guard let text = inputContainerView.inputTextField.text else { return }
        let properties = [K.FstoreMessage.textField : text]
        sendMessageWithProperties(properties: properties)
    }
    
    private func sendMessageWithImageUrl(imageUrl : String , image :UIImage){
        
        let properties = [K.FstoreMessage.imageUrlField : imageUrl,
                          K.FstoreMessage.imageWidth : image.size.width ,
                          K.FstoreMessage.imageHeigt : image.size.height] as [String : Any]
        sendMessageWithProperties(properties: properties )
    }
    
    
    private func sendMessageWithProperties(properties : [String:Any]){
        //guard let text = inputTextField.text else { return }
        guard let toId = user?.id else { return }
        guard let fromId = Auth.auth().currentUser?.uid else { return}
        let timestamp : NSNumber = NSNumber(value: Int(NSDate().timeIntervalSince1970))
        let ref = db.collection(K.FstoreMessage.collectionName)
        let messageId = ref.document().documentID
        
        var  values = [
            K.FstoreMessage.toId:toId ,
            K.FstoreMessage.fromId : fromId ,
            K.FstoreMessage.timestamp : timestamp
            ] as [String : Any]
        //append properties dictionay onto values somehow ??
        //key $0 , value $1
        properties.forEach({values[$0] = $1})
        
        
        ref.document(messageId).setData(values) { (error) in
            if error != nil {
                print(error!.localizedDescription)
                return
            } else {
                self.inputContainerView.inputTextField.text = nil
                print("text message saved into firebase !")
                
                //saving data with refrence for current user
                self.db.collection(K.FstoreMessage.collectionName).document(fromId).collection(K.FstoreMessage.userMessage).document(toId).setData([messageId : timestamp], merge: true)
                
                // saving data for recipient user
                self.db.collection(K.FstoreMessage.collectionName).document(toId).collection(K.FstoreMessage.userMessage).document(fromId).setData([messageId : timestamp],merge: true)
                
            }
        }
        
        
    }
    
   
    
    //MARK: - my custom zooming logic
    
    var startingFrame : CGRect?
    var blackBackgroundView :UIView?
    var startingImageView : UIImageView?
    
    func performZoomInStartingForImageView(startingImageView:UIImageView){
        
        self.startingImageView = startingImageView
        self.startingImageView?.isHidden = true
        startingFrame = startingImageView.superview?.convert( startingImageView.frame, to: nil)
        //print(startingFrame)
        
        let zoomingImageView = UIImageView(frame: startingFrame!)
        zoomingImageView.backgroundColor = .red
        zoomingImageView.image = startingImageView.image
        zoomingImageView.isUserInteractionEnabled = true
        zoomingImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleZoonOut)))
        
        if let keyWindow = UIApplication.shared.keyWindow{
            blackBackgroundView = UIView(frame: keyWindow.frame)
            self.blackBackgroundView?.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            self.blackBackgroundView?.alpha = 0
            keyWindow.addSubview(blackBackgroundView!)
            
            
            
            keyWindow.addSubview(zoomingImageView)
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.blackBackgroundView!.alpha = 1
                self.inputContainerView.alpha = 0
                //math ?
                //h2 / w1 = h1 / w1
                // h2 = h1/w1*w2
                
                let height = self.startingFrame!.height / self.startingFrame!.width * keyWindow.frame.width
                
                zoomingImageView.frame = CGRect(x: 0, y: 0, width: keyWindow.frame.width, height: height)
                zoomingImageView.center = keyWindow.center
            }, completion: nil)
            
            
            
        }
    }
    
    @objc func handleZoonOut(tapGesture : UITapGestureRecognizer ){
        if let zoomOutImageView = tapGesture.view{
            
            zoomOutImageView.layer.cornerRadius = 16
            zoomOutImageView.layer.masksToBounds = true
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                zoomOutImageView.frame = self.startingFrame!
                self.blackBackgroundView?.alpha = 0
                
            }) { (completed) in
                //do something later here
                zoomOutImageView.removeFromSuperview()
                self.inputContainerView.alpha = 1
                self.startingImageView?.isHidden = false
            }
        }
    }
}
