//
//  Configuration.swift
//  CTChatTrial2
//
//  Created by Jasmin Ceco on 08/01/2018.
//

import Foundation
public class Configuration{
    public static var shouldShowMessagesHeader: Bool = false
    public static var messagesTableViewTopConstraint: Int = {
        if Configuration.shouldShowMessagesHeader{
            return 124
        }
        return 0
    }()
    
    public static var ChatBubbleFromColor = UIColor(r: 0, g: 137, b: 249)
    public static var ChatBubbleToColor = UIColor(r: 240, g: 240, b: 240)
}
