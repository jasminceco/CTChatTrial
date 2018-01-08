//
//  ViewController.swift
//  CTChatTrial2
//
//  Created by jasminceco on 01/04/2018.
//  Copyright (c) 2018 jasminceco. All rights reserved.
//

import UIKit


public protocol NewMessageControllerDelagate :class{
    func startChatNewChatWith(user: User, currentUser: String)
}


public class NewMessageController: UITableViewController {
    
    let cellId = "cellId"
    
    public var users = [User]()
    weak public var delegate: NewMessageControllerDelagate!
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        
        tableView.register(UserCell.self, forCellReuseIdentifier: cellId)
        
        fetchUser()
    }
    
    func fetchUser() {
        NotificationCenter.default.post(name:.fetchUsers, object: self)
    }
    
   @objc func handleCancel() {
       self.navigationController?.popViewController(animated: true)
    }    
    override public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserCell
        
        let user = users[indexPath.row]
        cell.textLabel?.text = user.name
        cell.detailTextLabel?.text = user.email
        
        if let profileImageUrl = user.profileImageUrl {            
            cell.profileImageView.loadImageUsingCacheWithUrlString(profileImageUrl)
        }
        
        return cell
    }
    
    override public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    var messagesController: MessagesController?
    
    override public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        self.navigationController?.popViewController(animated: true)
        NotificationCenter.default.post(name:.openNewChat, object: self, userInfo: self.users[indexPath.row].toJSON())
    }

}








