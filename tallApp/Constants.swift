//
//  Constants.swift
//  tallApp
//
//  Created by Robin Tilman on 22/06/16.
//  Copyright © 2016 Robin Tilman. All rights reserved.
//

import Foundation
import UIKit

var user_username:String = String(NSUserDefaults.standardUserDefaults().objectForKey("user_text_username"))
var user_taille:String = String(NSUserDefaults.standardUserDefaults().objectForKey("user_text_taille"))

let shadow_color: CGFloat = 157.0 / 255.0

let KEY_UID = "uid"

let SEGUE_LOGGED_IN = "loggedIn"

let STATUS_ACCOUNT_NONEXIST = 17011