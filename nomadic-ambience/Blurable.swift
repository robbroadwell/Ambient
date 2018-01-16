//
//  Blurable.swift
//  nomadic-ambience
//
//  Created by Rob Broadwell on 1/13/18.
//  Copyright © 2018 Rob Broadwell. All rights reserved.
//

import UIKit

extension UIView {
    
    func blur() {
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        
        blurEffectView.frame = self.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(blurEffectView)
    }
    
}
