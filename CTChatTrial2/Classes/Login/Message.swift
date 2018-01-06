//
//  ViewController.swift
//  CTChatTrial2
//
//  Created by jasminceco on 01/04/2018.
//  Copyright (c) 2018 jasminceco. All rights reserved.
//

import UIKit
import ObjectMapper

public class Message: Mappable  {
    
   public  var fromId: String?
  public   var text: String?
    public var timestamp: NSNumber?
   public  var toId: String?
   public  var imageUrl: String?
   public  var videoUrl: String?
    public var imageWidth: NSNumber?
   public  var imageHeight: NSNumber?
    
    required public init?(map: Map) {}
    
    
    deinit {
        print("---------------MyChat DEINIT-------------")
    }
    
    public func mapping(map: Map) {
        fromId                    <- map["fromId"]
        text                      <- map["text"]
        timestamp                 <- map["timestamp"]
        toId                      <- map["toId"]
        imageUrl                  <- map["imageUrl"]
        videoUrl                  <- map["videoUrl"]
        imageWidth                <- map["imageWidth"]
        imageHeight               <- map["imageHeight"]
        
        chatPartnerID               <- map["chatPartnerID"]
        
    }
    
    public var chatPartnerID : String  = ""
    public var chatPartnerFullName : String  = ""

    
}
