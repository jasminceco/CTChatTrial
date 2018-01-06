//
//  ViewController.swift
//  CTChatTrial2
//
//  Created by jasminceco on 01/04/2018.
//  Copyright (c) 2018 jasminceco. All rights reserved.
//

import Foundation
import ObjectMapper

public class MyChat {
    
    var displayName: String!
    var toUserID: String!
    var fromUserID: String!
    var message: String!
    var date: Date!
    
//    var type: Int64!
//    var isFirstMsg: Int64!
//    var messageStatus: String!
//    var messageID: String!
//    var ChatMMSData: Data!
//    var fromUserDispalyName: String!
    
    required public init?(map: Map) {}
    init() {}
    
    deinit {
        print("---------------MyChat DEINIT-------------")
    }
    
    public func mapping(map: Map) {
        displayName                         <- map["displayName"]
        toUserID                            <- map["toUserID"]
        fromUserID                          <- map["fromUserID"]
        message                             <- map["message"]
        date                                <- map["date"]
        
    }
}
