//
//  LoginController+handlers.swift
//  ChatApplication
//
//  Created by Yash Patel on 2020-06-10.
//  Copyright © 2020 Darshan Patel. All rights reserved.
//

import UIKit

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
        print("cancel ")
        dismiss(animated: true, completion: nil)
    }
    

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print(info[.originalImage])
        
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

}
