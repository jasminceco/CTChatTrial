//
//  ViewController.swift
//  CTChatTrial2
//
//  Created by jasminceco on 01/04/2018.
//  Copyright (c) 2018 jasminceco. All rights reserved.
//

import UIKit

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}

enum SelectedTab: Int{
    case conversation = 0
    case contacts = 1
}


public var messagesDictionary = [String: Message]()

public class MessagesController: UIViewController, UITableViewDelegate, UITableViewDataSource, NewMessageControllerDelagate {

    let cellId = "cellId"
    
    var messages = [Message]()
    public var users = [CTUser]()
    
    public  var currentUser: CTUser!{
        didSet{
            self.setupNavBarWithUser(currentUser)
        }
    }
    var selectedTab = SelectedTab.conversation
    public var tableView = UITableView()

    lazy var menuBar: MenuBar = {
        let mb = MenuBar()
        mb.homeController = self
        return mb
    }()
    
    fileprivate func setupMenuBar() {
        navigationController?.hidesBarsOnSwipe = true
        if Configuration.shouldShowMessagesHeader{
            let redView = UIView()
            redView.backgroundColor = UIColor.lightText
            view.addSubview(redView)
            view.addConstraintsWithFormat(format: "H:|[v0]|", views: redView)
            view.addConstraintsWithFormat(format: "V:|-64-[v0(60)]|", views: redView)
            
            redView.addSubview(menuBar)
            redView.addConstraintsWithFormat(format: "H:|[v0]|", views: menuBar)
            redView.addConstraintsWithFormat(format: "V:|[v0]|", views: menuBar)  
        }
        view.addSubview(tableView)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views:tableView)
        view.addConstraintsWithFormat(format: "V:|-\(Configuration.messagesTableViewTopConstraint)-[v0]|", views: tableView)
       
        self.view.backgroundColor = Configuration.ChatViewsBackgroundColoar
        self.tableView.backgroundColor = Configuration.ChatViewsBackgroundColoar
    }
    
     public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        menuBar.horizontalBarLeftAnchorConstraint?.constant = scrollView.contentOffset.x / 4
    }
    
    public func selectedTab(_ at: Int) {
        if at != 0{

            self.users.removeAll()
            fetchUser()
            
            self.selectedTab = SelectedTab.contacts
            self.tableView.reloadData()
            return
        }
        self.messages.removeAll()
        self.selectedTab = SelectedTab.conversation
        self.handleReloadTable()
    }
    
    func fetchUser() {
        NotificationCenter.default.post(name:.fetchUsers, object: self)
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
         setupMenuBar()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        
        let image = UIImage(named: "new_msg_icon")
    
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(handleNewMessage))
        navigationItem.rightBarButtonItem?.customView?.backgroundColor = .orange
        tableView.register(UserCell.self, forCellReuseIdentifier: cellId)
        tableView.allowsMultipleSelectionDuringEditing = true
        NotificationCenter.default.addObserver(self, selector: #selector(MessageRecived(_:)), name: .userMessageRecived, object: nil)
        
        
    }
    public override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
        self.selectedTab = .conversation
        self.tableView.reloadData()
        DispatchQueue.main.async {
            let selectedIndexPath = IndexPath(item: 0, section: 0)
            self.menuBar.collectionView.selectItem(at: selectedIndexPath, animated: false, scrollPosition: UICollectionViewScrollPosition())
            let x = CGFloat(selectedIndexPath.item) * self.menuBar.frame.width / 2
            self.menuBar.horizontalBarLeftAnchorConstraint?.constant = x
            
            UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.menuBar.layoutIfNeeded()
            }, completion: nil)
        }

    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        self.tableView.addTopBorderWithHeight(height: 4, color: .lightGray, leftOffset: 0, rightOffset: 0, topOffset: -3)
    }
 
    
    @objc func MessageRecived(_ notification: NSNotification) {
        self.handleReloadTable()
    }

   
     public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
     public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        NotificationCenter.default.post(name:.deleteMessages, object: self, userInfo: self.messages[indexPath.row].toJSON())
    }
    
     public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.selectedTab.rawValue == 0{
            return messages.count
        }else{
            return users.count
        }
    }
    
     public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserCell
        cell.backgroundColor = Configuration.ChatViewsBackgroundColoar
        if self.selectedTab == .conversation{
            cell.message = messages[indexPath.row]
        }else{
            cell.user = users[indexPath.row]
        }
        return cell
    }
    
     public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
      public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         if self.selectedTab == .conversation{
            NotificationCenter.default.post(name:.openChat, object: self, userInfo: self.messages[indexPath.row].toJSON())
         }else{
            NotificationCenter.default.post(name:.openNewChat, object: self, userInfo: self.users[indexPath.row].toJSON())
        }
    }
  
    @objc func handleReloadTable() {
        
        self.messages = Array(messagesDictionary.values)
        self.messages.sort(by: { (message1, message2) -> Bool in
            
            return message1.timestamp?.int32Value > message2.timestamp?.int32Value
        })
        
        //this will crash because of background thread, so lets call this on dispatch_async main thread
        DispatchQueue.main.async(execute: {
            self.tableView.reloadData()
        })
    }
    
    
    @objc func handleNewMessage() {
        let newMessageController = NewMessageController()
        newMessageController.messagesController = self
        newMessageController.delegate = self
        
       self.navigationController?.pushViewController(newMessageController, animated: true)
    }
    


    func setupNavBarWithUser(_ user: CTUser) {
        messages.removeAll()
        messagesDictionary.removeAll()
        tableView.reloadData()

        let titleView = UIView()
        titleView.frame = CGRect(x: 0, y: 0, width: 100, height: 40)

        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        titleView.addSubview(containerView)
        
        let profileImageView = UIImageView()
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.cornerRadius = 20
        profileImageView.clipsToBounds = true
        if let profileImageUrl = user.profileImageUrl {
            profileImageView.loadImageUsingCacheWithUrlString(profileImageUrl)
        }
        
        containerView.addSubview(profileImageView)

        profileImageView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        let nameLabel = UILabel()
        
        containerView.addSubview(nameLabel)
        nameLabel.text = user.name
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8).isActive = true
        nameLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        nameLabel.heightAnchor.constraint(equalTo: profileImageView.heightAnchor).isActive = true
        
        containerView.centerXAnchor.constraint(equalTo: titleView.centerXAnchor).isActive = true
        containerView.centerYAnchor.constraint(equalTo: titleView.centerYAnchor).isActive = true
        
        self.navigationItem.titleView = titleView
    }
    
    public  func showChatControllerForUser(_ user: CTUser) {
        DispatchQueue.main.async {
            let chatLogController = ChatLogController(collectionViewLayout: UICollectionViewFlowLayout())
            chatLogController.user = user
            self.navigationController?.pushViewController(chatLogController, animated: true)
        }
    }
    
    public  func startChatWith(user: CTUser, currentUser: CTUser?) {
        DispatchQueue.main.async {
            let chatLogController = ChatLogController(collectionViewLayout: UICollectionViewFlowLayout())
            chatLogController.user = user
            chatLogController.currentUser = currentUser
            self.navigationController?.pushViewController(chatLogController, animated: true)
        }
    }
    
    public func startChatNewChatWith(user: CTUser, currentUser: CTUser?) {
        DispatchQueue.main.async {
            let chatLogController = ChatLogController(collectionViewLayout: UICollectionViewFlowLayout())
            chatLogController.user = user
            chatLogController.currentUser = currentUser
            self.navigationController?.pushViewController(chatLogController, animated: true)
        }
    }
    
    @objc func handleLogout() {
        NotificationCenter.default.post(name: .logout, object: self)
    }

}

