//
//  Reviewable.swift
//  nomadic-ambience
//
//  Created by Rob Broadwell on 1/13/18.
//  Copyright © 2018 Rob Broadwell. All rights reserved.
//

import UIKit

protocol Reviewable {
    
}

extension Reviewable where Self: UIViewController {
    func review() {
        let controller = UIStoryboard.instantiateInitialViewController(UIStoryboard(name: "Reviewable", bundle: nil))
        
        guard self.view != nil,
            let vc = controller() as? ReviewableViewController else { return }
        
        self.view.addSubview(vc.view)
    }
}

