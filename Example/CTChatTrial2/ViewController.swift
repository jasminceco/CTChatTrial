//
//  ViewController.swift
//  CTChatTrial2
//
//  Created by jasminceco on 01/04/2018.
//  Copyright (c) 2018 jasminceco. All rights reserved.
//

import UIKit
import CTChatTrial2
import Firebase



class ViewController: UIViewController {
    
    var DB_User_Table = "users"
    var toUserID:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(logout), name: .logout, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(fetchUsers), name: .fetchUsers, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(sendCHAT(_:)), name: .sendChat, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(deleteMessages(_:)), name: .deleteMessages, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(openChat(_:)), name: .openChat, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(openChatwithNewUser(_:)), name: .openNewChat, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(uploadToFirebaseStorageUsingImage(_:)), name: .sendImage, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(uploadToFirebaseStorageUsingVideo(_:)), name: .sendVideo, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleLoging(_:)), name: .hangleLogin, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleRegister(_:)), name: .hangleRegister, object: nil)
        Configuration.shouldShowMessagesHeader = true
        Configuration.ChatBubbleFromColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.checkIfUserIsLoggedIn(){
            self.LogUserHierarchy(vc:self)
        }else{
            self.LoginHierarchy()
        }
    }
    
    func LogUserHierarchy(vc: UIViewController){
        self.observeUserMessages()
        DispatchQueue.main.async {
            let inbox = MessagesController()
            guard let uid = Auth.auth().currentUser?.uid else{
                return
            }
            
            Database.database().reference().child(self.DB_User_Table).child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
                if let json = snapshot.value as? [String: AnyObject] {
                    let user = User(JSON: json)
                    inbox.currentUser = user
                   vc.navigationController?.pushViewController(inbox, animated: true)
                }
                
            }, withCancel: nil)
            
        }
    }
    
    
    func LoginHierarchy() {
        DispatchQueue.main.async {
            let login = LoginController()
            self.navigationController?.pushViewController(login, animated: true)
        }
    }
    
    func observeMessages() {
        guard let uid = Auth.auth().currentUser?.uid, let toId = toUserID else {
            return
        }
        
        let userMessagesRef = Database.database().reference().child("user-messages").child(uid).child(toId)
        userMessagesRef.observe(.childAdded, with: { (snapshot) in
            
            let messageId = snapshot.key
            let messagesRef = Database.database().reference().child("messages").child(messageId)
            messagesRef.observeSingleEvent(of: .value, with: { (snapshot) in
                
                guard let dictionary = snapshot.value as? [String: AnyObject] else {
                    return
                }
                NotificationCenter.default.post(name: .chatMessageRecived, object: self, userInfo: Message(JSON: dictionary)?.toJSON())
            }, withCancel: nil)
            
        }, withCancel: nil)
    }
    
    @objc   func observeUserMessages() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        let ref = Database.database().reference().child("user-messages").child(uid)
        ref.observe(.childAdded, with: { (snapshot) in
            
            let userId = snapshot.key
            Database.database().reference().child("user-messages").child(uid).child(userId).observe(.childAdded, with: { (snapshot) in
                
                let messageId = snapshot.key
                self.fetchMessageWithMessageId(messageId)
                
            }, withCancel: nil)
            
        }, withCancel: nil)
        
        ref.observe(.childRemoved, with: { (snapshot) in
            print(snapshot.key)
            print(messagesDictionary)
            
            messagesDictionary.removeValue(forKey: snapshot.key)
            
        }, withCancel: nil)
    }
    
    fileprivate func fetchMessageWithMessageId(_ messageId: String) {
        let messagesReference = Database.database().reference().child("messages").child(messageId)
        
        messagesReference.observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let message = Message(JSON: dictionary)
                
                message?.chatPartnerID = self.chatPartnerId(fromId: (message?.fromId)!, toId: (message?.toId)!)!
                let ref = Database.database().reference().child("users").child((message?.chatPartnerID)!)
                ref.observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    if let dictionary = snapshot.value as? [String: AnyObject] {
                        message?.chatPartnerFullName = (dictionary["name"] as? String)!
                        
                        
                        if let profileImageUrl = dictionary["profileImageUrl"] as? String {
                            message?.imageUrl = profileImageUrl
                        }
                    }
                    NotificationCenter.default.post(name: .userMessageRecived, object: self, userInfo: message?.toJSON())
                    
                    
                }, withCancel: nil)
                if let chatPartnerId = message?.chatPartnerID {
                    messagesDictionary[chatPartnerId] = message
                }
                NotificationCenter.default.post(name: .userMessageRecived, object: self, userInfo: message?.toJSON())
            }
            
        }, withCancel: nil)
    }
    
    func chatPartnerId(fromId: String, toId: String) -> String? {
        return fromId == Auth.auth().currentUser?.uid ? toId : fromId
    }
    
    
    public func checkIfUserIsLoggedIn()-> Bool {
        if Auth.auth().currentUser?.uid == nil {
            return false
        } else {
            return true
        }
    }
    
    @objc func fetchUsers(){
        Database.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let user = User(JSON: dictionary)
                if UIApplication.topViewController() is NewMessageController{
                    let vc = UIApplication.topViewController() as!  NewMessageController
                    
                    user?.id = snapshot.key
                    vc.users.append(user!)
                    
                    //this will crash because of background thread, so lets use dispatch_async to fix
                    DispatchQueue.main.async(execute: {
                        vc.tableView.reloadData()
                    })
                }
                if UIApplication.topViewController() is MessagesController{
                    let vc = UIApplication.topViewController() as!  MessagesController
                    
                    user?.id = snapshot.key
                    vc.users.append(user!)
                    
                    //this will crash because of background thread, so lets use dispatch_async to fix
                    DispatchQueue.main.async(execute: {
                        vc.tableView.reloadData()
                    })
                }
            }
        }, withCancel: nil)
    }
    
    @objc func logout(){
        do {
            try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError)
            return
        }
        if UIApplication.topViewController() is MessagesController{
            let vc = UIApplication.topViewController() as! MessagesController
            vc.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    @objc func sendCHAT(_ notification: NSNotification) {
        
        if let chatLogController = notification.object as? ChatLogController,
            let properties = notification.userInfo as? [String:AnyObject] {
            let ref = Database.database().reference().child("messages")
            let childRef = ref.childByAutoId()
            let toId = chatLogController.user!.id!
            let fromId = Auth.auth().currentUser!.uid
            let timestamp = Int(Date().timeIntervalSince1970)
            
            var values: [String: AnyObject] = ["toId": toId as AnyObject, "fromId": fromId as AnyObject, "timestamp": timestamp as AnyObject]
            
            //append properties dictionary onto values somehow??
            //key $0, value $1
            properties.forEach({values[$0] = $1})
            
            childRef.updateChildValues(values) { (error, ref) in
                if error != nil {
                    print(error!)
                    return
                }
                
                chatLogController.inputContainerView.inputTextField.text = nil
                
                let userMessagesRef = Database.database().reference().child("user-messages").child(fromId).child(toId)
                
                let messageId = childRef.key
                userMessagesRef.updateChildValues([messageId: 1])
                
                let recipientUserMessagesRef = Database.database().reference().child("user-messages").child(toId).child(fromId)
                recipientUserMessagesRef.updateChildValues([messageId: 1])
            }
        }
    }
    
    @objc func deleteMessages(_ notification: NSNotification) {
        if let messagesController = notification.object as?  MessagesController,
            let json = notification.userInfo as? [String:AnyObject] {
            if  let message = Message(JSON:json){
                guard let uid = Auth.auth().currentUser?.uid else {
                    return
                }
                debugPrint(message)
                let chatPartnerId = message.chatPartnerID
                Database.database().reference().child("user-messages").child(uid).child(chatPartnerId).removeValue(completionBlock: { (error, ref) in
                    
                    if error != nil {
                        print("Failed to delete message:", error!)
                        return
                    }
                    messagesDictionary.removeValue(forKey: chatPartnerId)
                    messagesController.tableView.reloadData()
                })
            }
        }
    }
    
    @objc func openChat(_ notification: NSNotification) {
        if let messagesController = notification.object as?  MessagesController,
            let json = notification.userInfo as? [String:AnyObject] {
            if  let message = Message(JSON:json){
                let chatPartnerId = message.chatPartnerID
                
                let ref = Database.database().reference().child("users").child(chatPartnerId)
                ref.observeSingleEvent(of: .value, with: { (snapshot) in
                    guard let dictionary = snapshot.value as? [String: AnyObject] else {
                        return
                    }
                    
                    if  let user = User(JSON: dictionary){
                        user.id = chatPartnerId
                        self.toUserID = user.id
                        self.observeMessages()
                        messagesController.startChatWith(user: user, currentUser: (Auth.auth().currentUser?.uid)!)
                    }
                }, withCancel: nil)
            }
        }
    }
    
    @objc func openChatwithNewUser(_ notification: NSNotification) {
        if let newMessageController = notification.object as?  NewMessageController,
            let json = notification.userInfo as? [String:AnyObject] {
            if  let user = User(JSON:json){
                self.toUserID = user.id
                self.observeMessages()
                newMessageController.navigationController?.popViewController({
                    if UIApplication.topViewController() is MessagesController{
                        let messagesController = UIApplication.topViewController() as!  MessagesController
                        
                        messagesController.startChatWith(user: user, currentUser: (Auth.auth().currentUser?.uid)!)
                    }
                })
    
                
            }
        }
        if let messagesController = notification.object as?  MessagesController,
            let json = notification.userInfo as? [String:AnyObject] {
            if  let user = User(JSON:json){
                self.toUserID = user.id
                self.observeMessages()
                messagesController.startChatWith(user: user, currentUser: (Auth.auth().currentUser?.uid)!)
                
            }
        }
    }
    
    @objc func uploadToFirebaseStorageUsingVideo(_ notification: NSNotification) {
        if let chatLogVC = notification.object as?  ChatLogController,
            let info = notification.userInfo as? [String:AnyObject] {
            if let url = info["videoUrl"] as? URL {
                let filename = UUID().uuidString + ".mov"
                let uploadTask = Storage.storage().reference().child("message_movies").child(filename).putFile(from: url, metadata: nil, completion: { (metadata, error) in
                    
                    if error != nil {
                        print("Failed upload of video:", error!)
                        return
                    }
                    
                    if let videoUrl = metadata?.downloadURL()?.absoluteString {
                        if let thumbnailImage = chatLogVC.thumbnailImageForFileUrl(url) {
                            
                            let imageName = UUID().uuidString
                            let ref = Storage.storage().reference().child("message_images").child(imageName)
                            
                            if let uploadData = UIImageJPEGRepresentation(thumbnailImage, 0.2) {
                                ref.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                                    
                                    if error != nil {
                                        print("Failed to upload image:", error!)
                                        return
                                    }
                                    
                                    if let imageUrl = metadata?.downloadURL()?.absoluteString {
                                        let properties: [String: AnyObject] = ["imageUrl": imageUrl as AnyObject, "imageWidth": thumbnailImage.size.width as AnyObject, "imageHeight": thumbnailImage.size.height as AnyObject, "videoUrl": videoUrl as AnyObject]
                                        chatLogVC.sendMessageWithProperties(properties)
                                    }
                                    
                                })
                            }
                        }
                    }
                })
                
                uploadTask.observe(.progress) { (snapshot) in
                    if let completedUnitCount = snapshot.progress?.completedUnitCount {
                        chatLogVC.navigationItem.title = String(completedUnitCount)
                    }
                }
                
                uploadTask.observe(.success) { (snapshot) in
                    chatLogVC.navigationItem.title = chatLogVC.user?.name
                }
            }
        }
    }
    
    
    @objc func uploadToFirebaseStorageUsingImage(_ notification: NSNotification) {
        if let chatLogVC = notification.object as?  ChatLogController,
            let info = notification.userInfo as? [String:AnyObject] {
            
            var selectedImageFromPicker: UIImage?
            
            if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
                selectedImageFromPicker = editedImage
            } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
                
                selectedImageFromPicker = originalImage
            }
            
            if let selectedImage = selectedImageFromPicker {
                
                let imageName = UUID().uuidString
                let ref = Storage.storage().reference().child("message_images").child(imageName)
                
                if let uploadData = UIImageJPEGRepresentation(selectedImage, 0.2) {
                    ref.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                        
                        if error != nil {
                            print("Failed to upload image:", error!)
                            return
                        }
                        
                        if let imageUrl = metadata?.downloadURL()?.absoluteString {
                            chatLogVC.sendMessageWithImageUrl(imageUrl,  image: selectedImage)
                            
                        }
                        
                    })
                }
            }
            
        }
    }
    
    @objc func handleLoging(_ notification: NSNotification) {
        if let login = notification.object as?  LoginController,
            let info = notification.userInfo as? [String:String] {
            
            guard let email = info["email"], let password = info["password"] else{
                return
            }
            Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
                if error != nil {
                    // popup
                    return
                }
                
                guard let uid = Auth.auth().currentUser?.uid else { return }
                
                Database.database().reference().child(self.DB_User_Table).child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
                    if let _ = snapshot.value as? [String: AnyObject] {
                        login.navigationController?.popViewController {
                            login.navigationController?.viewControllers.removeAll()
                        }
                    }
                    
                }, withCancel: nil)
            })
            
            
        }
    }
    
    @objc func handleRegister(_ notification: NSNotification) {
        if let login = notification.object as?  LoginController,
            let info = notification.userInfo as? [String:String] {
            
            guard let email = info["email"], let password = info["password"], let name = info["name"] else{
                return
            }
            Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
                
                if error != nil {
                    return
                }
                
                guard let uid = user?.uid else {return}
                //successfully authenticated user
                let imageName = UUID().uuidString
                let storageRef = Storage.storage().reference().child("profile_images").child("\(imageName).jpg")
                
                if let profileImage = login.profileImageView.image, let uploadData = UIImageJPEGRepresentation(profileImage, 0.1) {
                    
                    storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                        
                        if error != nil {
                            print(error!)
                            return
                        }
                        
                        if let profileImageUrl = metadata?.downloadURL()?.absoluteString {
                            
                            
                            
                            let ref = Database.database().reference()
                            let usersReference = ref.child(self.DB_User_Table).child(uid)
                            let values : [String : Any] = ["name": name as Any, "email": email as Any, "profileImageUrl": profileImageUrl as Any]
                            
                            usersReference.updateChildValues(values as [String : Any], withCompletionBlock: { (err, ref) in
                                if err != nil {
                                    print(err!)
                                    return
                                }
                                if let _ = User(JSON: values){
                                    //                                        print(user.toJSON())
                                    self.LogUserHierarchy(vc: self)
                                    
                                }
                            })
                        }
                    })
                }
            }
        }
    }
}

