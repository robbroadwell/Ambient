//
//  RoundedCornerView.swift
//  nomadic-ambience
//
//  Created by Rob Broadwell on 1/13/18.
//  Copyright © 2018 Rob Broadwell. All rights reserved.
//

import UIKit

@IBDesignable
class RoundedCornerView: UIView {
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        didSet {
            layer.borderColor = borderColor?.cgColor
        }
    }
    
}
