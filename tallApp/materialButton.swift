//
//  materialButton.swift
//  tallApp
//
//  Created by Robin Tilman on 22/06/16.
//  Copyright © 2016 Robin Tilman. All rights reserved.
//

import UIKit

class materialButton: UIButton {
    override func awakeFromNib() {
        
        layer.cornerRadius = 2.0
        layer.shadowColor = UIColor(red: shadow_color, green: shadow_color, blue: shadow_color, alpha: 0.5).CGColor
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 5.0
        layer.shadowOffset = CGSizeMake(0.0, 2.0)
        
    }
    
    
}
