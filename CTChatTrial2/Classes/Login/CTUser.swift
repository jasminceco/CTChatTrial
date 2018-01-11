//
//  User.swift
//  CTChatTrial2
//
//  Created by Jasmin Ceco on 06/01/2018.
//

import Foundation
import ObjectMapper

public class CTUser: Mappable {
    public var id: String?
    public var name: String?
    public var email: String?
    public var profileImageUrl: String?
    required public init?(map: Map) {
    }
    init() {
        
    }
    
    deinit {
        print("---------------User DEINIT-------------")
    }
    public func mapping(map: Map) {
        id                           <- map["id"]
        name                         <- map["name"]
        email                        <- map["email"]
        profileImageUrl              <- map["profileImageUrl"]
        
    }
}
