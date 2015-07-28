//
//  UserInfo.swift
//  Tumbleweed
//
//  Created by Chloe Stars on 7/28/15.
//  Copyright © 2015 Chloe Stars. All rights reserved.
//

import Foundation
import AVFoundation

class UserInfo {
    static let sharedUserInfo = UserInfo()
    
    var blogs : Array<String>!
    var currentPlayer : AVPlayer?
}