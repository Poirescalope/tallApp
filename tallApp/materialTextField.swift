//
//  materialTextField.swift
//  tallApp
//
//  Created by Robin Tilman on 22/06/16.
//  Copyright © 2016 Robin Tilman. All rights reserved.
//

import UIKit

class materialTextField: UITextField {

    
    
    override func awakeFromNib() {
        layer.cornerRadius = 2.0
        layer.borderColor = UIColor(red: shadow_color, green: shadow_color, blue: shadow_color, alpha: 0.1).CGColor
        layer.borderWidth = 1.0
    }
    override func textRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectInset(bounds, 10, 0) // decaller le texter
    }
    
    override func editingRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectInset(bounds, 10, 0)
    }
}
