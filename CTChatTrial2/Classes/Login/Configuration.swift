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
    public static var ChatViewsBackgroundColoar = UIColor(r: 248, g: 248, b: 248)
    public static var ChatBubbleToColor = UIColor(r: 240, g: 240, b: 240)
    public static var ChatBubbleMaxWidth: Int = 200
    public static var ChatBubbleHasBlip: Bool = true
    
}
