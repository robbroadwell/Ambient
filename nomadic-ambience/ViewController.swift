//
//  ViewController.swift
//  nomadic-ambience
//
//  Created by Rob Broadwell on 1/8/18.
//  Copyright © 2018 Rob Broadwell. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var knobPlaceholder: UIView!
    
    var knob: Knob!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        knob = Knob(frame: knobPlaceholder.bounds)
        knob.addTarget(self, action: #selector(knobValueChanged(knob:)), for: .allEvents)
        knob.isUserInteractionEnabled = true
        knobPlaceholder.addSubview(knob)
        
        view.tintColor = UIColor.red
        
        knob.value = 0.5
    }
    
    @objc func knobValueChanged(knob: Knob) {
        print(knob.value)
    }
    
}

