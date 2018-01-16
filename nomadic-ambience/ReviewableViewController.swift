//
//  ReviewableViewController.swift
//  nomadic-ambience
//
//  Created by Rob Broadwell on 1/13/18.
//  Copyright © 2018 Rob Broadwell. All rights reserved.
//

import UIKit

class ReviewableViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var background: UIButton!
    
    @IBAction func backgroundPressed(_ sender: UIButton) {
        print("background")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        background.blur()
        
    }

}
