//
//  ChatMessageCell.swift
//  CTChatTrial2
//
//  Created by jasminceco on 01/04/2018.
//  Copyright (c) 2018 jasminceco. All rights reserved.
//

import UIKit

import MobileCoreServices
import AVFoundation
import Photos
import QuickLook


class PreviewController: QLPreviewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let firstView = self.childViewControllers.first    {
           
            for view in firstView.view.subviews    {
                if view.isKind(of: UIToolbar.self){
                    let v = view as! UIToolbar
                    v.items?.removeAll()
                    v.removeFromSuperview()
                }
                
                if view.isKind(of: UINavigationBar.self){
                   view.isHidden = true
                }
            }
        }
    }
    

    
}
public class ChatMessageCell: UICollectionViewCell {
    
    var message: Message?
    
    var chatLogController: ChatLogController?
    
    let activityIndicatorView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        aiv.translatesAutoresizingMaskIntoConstraints = false
        aiv.hidesWhenStopped = true
        return aiv
    }()
    
    lazy var playButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "play")
        button.tintColor = UIColor.white
        button.setImage(image, for: UIControlState())
        
        button.addTarget(self, action: #selector(handlePlay), for: .touchUpInside)
        
        return button
    }()
    
    var playerLayer: AVPlayerLayer?
    var player: AVPlayer?
    
    var myPreviewController : PreviewController = {
        let preview = PreviewController()
        return preview
    }()
     var FileURL: URL!
    @objc func handlePlay() {
        
        if let videoUrlString = message?.videoUrl, let url = URL(string:videoUrlString) {
         
            self.FileURL = url
            
            self.myPreviewController.dataSource = self
            self.myPreviewController.delegate = self
            self.myPreviewController.modalPresentationStyle = .pageSheet
            activityIndicatorView.startAnimating()
            playButton.isHidden = true
            
            self.chatLogController?.navigationController?.present(myPreviewController, animated: false, completion: nil)
           
//            player = AVPlayer(url: url)
//
//            playerLayer = AVPlayerLayer(player: player)
//            playerLayer?.frame = bubbleView.bounds
//            bubbleView.layer.addSublayer(playerLayer!)
//
//            player?.play()
            activityIndicatorView.startAnimating()
            playButton.isHidden = true
//
            print("Attempting to play video......???")
        }
    }
    
    override public func prepareForReuse() {
        super.prepareForReuse()
        playerLayer?.removeFromSuperlayer()
        player?.pause()
        activityIndicatorView.stopAnimating()
    }
    
    let textView: UITextView = {
        let tv = UITextView()
        tv.text = "SAMPLE TEXT FOR NOW"
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = UIColor.clear
        tv.textColor = .white
        tv.isEditable = false
        return tv
    }()
    
    static let blueColor = UIColor(r: 0, g: 137, b: 249)
    
    let bubbleView: UIView = {
        let view = UIView()
        view.backgroundColor = blueColor
        view.translatesAutoresizingMaskIntoConstraints = false
        if !Configuration.ChatBubbleHasBlip{
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        }
        return view
    }()
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 16
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let bubbleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        return imageView
    }()

    
    lazy var messageImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 16
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleZoomTap)))
        
        return imageView
    }()
    
    @objc func handleZoomTap(_ tapGesture: UITapGestureRecognizer) {
        if message?.videoUrl != nil {
            return
        }
        
        if let imageView = tapGesture.view as? UIImageView {
            //PRO Tip: don't perform a lot of custom logic inside of a view class
            self.chatLogController?.performZoomInForStartingImageView(imageView)
        }
    }
    
    var bubbleWidthAnchor: NSLayoutConstraint?
    var bubbleViewRightAnchor: NSLayoutConstraint?
    var bubbleViewLeftAnchor: NSLayoutConstraint?
    

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(bubbleView)
        bubbleView.addSubview(bubbleImageView)
        addSubview(textView)
        addSubview(profileImageView)
        
        bubbleView.addSubview(messageImageView)
        messageImageView.leftAnchor.constraint(equalTo: bubbleView.leftAnchor).isActive = true
        messageImageView.topAnchor.constraint(equalTo: bubbleView.topAnchor).isActive = true
        messageImageView.widthAnchor.constraint(equalTo: bubbleView.widthAnchor).isActive = true
        messageImageView.heightAnchor.constraint(equalTo: bubbleView.heightAnchor).isActive = true
        
        bubbleView.addSubview(playButton)
        //x,y,w,h
        playButton.centerXAnchor.constraint(equalTo: bubbleView.centerXAnchor).isActive = true
        playButton.centerYAnchor.constraint(equalTo: bubbleView.centerYAnchor).isActive = true
        playButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        playButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        bubbleView.addSubview(activityIndicatorView)
        //x,y,w,h
        activityIndicatorView.centerXAnchor.constraint(equalTo: bubbleView.centerXAnchor).isActive = true
        activityIndicatorView.centerYAnchor.constraint(equalTo: bubbleView.centerYAnchor).isActive = true
        activityIndicatorView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        activityIndicatorView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        //x,y,w,h
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        profileImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 32).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 32).isActive = true
        
        //x,y,w,h
        
        bubbleViewRightAnchor = bubbleView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8)
        bubbleViewRightAnchor?.isActive = true
        
        bubbleViewLeftAnchor = bubbleView.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8)
        bubbleView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        
        bubbleWidthAnchor = bubbleView.widthAnchor.constraint(equalToConstant: 200)
        bubbleWidthAnchor?.isActive = true
    
        bubbleView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        if Configuration.ChatBubbleHasBlip{
            bubbleView.addSubview(bubbleImageView)
            
            bubbleView.addConstraintsWithFormat(format: "H:|-(-6)-[v0]-(-6)-|", views: bubbleImageView)
            bubbleView.addConstraintsWithFormat(format: "V:|[v0]|", views: bubbleImageView)
        }
        
        if Configuration.ChatBubbleHasBlip{
             textView.leftAnchor.constraint(equalTo: bubbleView.leftAnchor, constant:6).isActive = true
            textView.rightAnchor.constraint(equalTo: bubbleView.rightAnchor, constant:-10).isActive = true
        }else{
            textView.leftAnchor.constraint(equalTo: bubbleView.leftAnchor, constant: 8).isActive = true
            textView.rightAnchor.constraint(equalTo: bubbleView.rightAnchor).isActive = true
        }
        
        textView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        
        textView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
     
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension ChatMessageCell: QLPreviewControllerDataSource, QLPreviewControllerDelegate{
    public func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return 1
    }
    public func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        return self.FileURL as QLPreviewItem
    }
    
    public func previewControllerWillDismiss(_ controller: QLPreviewController) {
        print("The Preview Controller Will be dismissed.")
         playButton.isHidden = false
        activityIndicatorView.stopAnimating()
    }
    
    public func previewControllerDidDismiss(_ controller: QLPreviewController) {
        print("The Preview Controller has been dismissed.")
        if self.myPreviewController != nil {
            self.myPreviewController.dataSource = nil
            self.myPreviewController.delegate = nil
            self.myPreviewController.removeFromParentViewController()
        }
    }
  
    
    
    
}
