//
//  NotificationNameExtention.swift
//  CTChatTrial2
//
//  Created by Jasmin Ceco on 06/01/2018.
//

import Foundation

public extension Notification.Name {
    static public let hangleLogin =  Notification.Name("hangleLogin")
    static  public let hangleRegister =  Notification.Name("hangleRegister")
    static public let fetchUsers =  Notification.Name("fetchUsers")
    static public let sendChat =  Notification.Name("sendChat")
    static public let userMessageRecived =  Notification.Name("userMessageRecived")
    static public let chatMessageRecived =  Notification.Name("chatMessageRecived")
    static public let observeUserMessages =  Notification.Name("observeUserMessages")
    static public let deleteMessages =  Notification.Name("deleteMessages")
    static public let openChat =  Notification.Name("openChat")
    static public let openNewChat =  Notification.Name("openNewChat")
    static public let logout =  Notification.Name("logout")
    static public let sendImage =  Notification.Name("sendImage")
    static public let sendVideo =  Notification.Name("sendVideo")
    
}
