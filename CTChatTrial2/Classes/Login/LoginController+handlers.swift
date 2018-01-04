//
//  LoginController+handlers.swift
//  gameofchats
//
//  Created by Brian Voong on 7/4/16.
//  Copyright © 2016 letsbuildthatapp. All rights reserved.
//

import UIKit


extension LoginController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func handleRegister() {
        guard let email = emailTextField.text, let password = passwordTextField.text, let name = nameTextField.text else {
            print("Form is not valid")
            return
        }
        
//        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
//
//            if error != nil {
//                print(error!)
//                return
//            }
//
//            guard let uid = user?.uid else {
//                return
//            }
//
//            //successfully authenticated user
//            let imageName = UUID().uuidString
//            let storageRef = Storage.storage().reference().child("profile_images").child("\(imageName).jpg")
//
//            if let profileImage = self.profileImageView.image, let uploadData = UIImageJPEGRepresentation(profileImage, 0.1) {
//
////            if let uploadData = UIImagePNGRepresentation(self.profileImageView.image!) {
//
//                storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
//
//                    if error != nil {
//                        print(error!)
//                        return
//                    }
//
//                    if let profileImageUrl = metadata?.downloadURL()?.absoluteString {
//
//                        let values = ["name": name, "email": email, "profileImageUrl": profileImageUrl]
//
//                        self.registerUserIntoDatabaseWithUID(uid, values: values as [String : AnyObject])
//                    }
//                })
//            }
//        }
    }
    
    fileprivate func registerUserIntoDatabaseWithUID(_ uid: String, values: [String: AnyObject]) {
//        let ref = Database.database().reference()
//        let usersReference = ref.child("users").child(uid)
//        
//        usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
//            
//            if err != nil {
//                print(err!)
//                return
//            }
//            
////            self.messagesController?.fetchUserAndSetupNavBarTitle()
////            self.messagesController?.navigationItem.title = values["name"] as? String
//            let user = User(dictionary: values)
//            self.messagesController?.setupNavBarWithUser(user)
//            
//            self.dismiss(animated: true, completion: nil)
//        })
    }
    
   @objc func handleSelectProfileImageView() {
        let picker = UIImagePickerController()
        
        picker.delegate = self
        picker.allowsEditing = true
        
        present(picker, animated: true, completion: nil)
    }
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            profileImageView.image = selectedImage
        }
        
        dismiss(animated: true, completion: nil)
        
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("canceled picker")
        dismiss(animated: true, completion: nil)
    }
    
}