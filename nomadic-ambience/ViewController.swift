//
//  ViewController.swift
//  nomadic-ambience
//
//  Created by Rob Broadwell on 1/8/18.
//  Copyright © 2018 Rob Broadwell. All rights reserved.
//

import UIKit

enum Control {
    case storm
    case fire
    case music
}

class ViewController: UIViewController {

    @IBOutlet weak var knobPlaceholder: UIView!
    
    var knob: Knob!
    var activeControl: Control = Control.fire {
        didSet {
            updateUI()
        }
    }
    
    var stormVolume: Float = 0.5
    var fireVolume: Float = 0.5
    var musicVolume: Float = 0.5
    
    func updateUI() {
        switch activeControl {
        case Control.storm:
            stormButton.tintColor = .red
            fireButton.tintColor = .black
            musicButton.tintColor = .black
            knob.value = stormVolume
        case Control.fire:
            stormButton.tintColor = .black
            fireButton.tintColor = .red
            musicButton.tintColor = .black
            knob.value = fireVolume
        case Control.music:
            stormButton.tintColor = .black
            fireButton.tintColor = .black
            musicButton.tintColor = .red
            knob.value = musicVolume
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        knob = Knob(frame: knobPlaceholder.bounds)
        knob.addTarget(self, action: #selector(knobValueChanged(knob:)), for: .allEvents)
        knob.isUserInteractionEnabled = true
        knobPlaceholder.addSubview(knob)
        
        view.tintColor = UIColor.red
        updateUI()
        
    }
    
    @objc func knobValueChanged(knob: Knob) {
        switch activeControl {
        case Control.storm:
            stormVolume = knob.value
        case Control.fire:
            fireVolume = knob.value
        case Control.music:
            musicVolume = knob.value
        }
    }
        
    @IBOutlet weak var stormButton: UIButton!
    @IBAction func stormButtonPressed(_ sender: UIButton) {
        activeControl = .storm
    }
    @IBOutlet weak var fireButton: UIButton!
    @IBAction func fireButtonPressed(_ sender: UIButton) {
        activeControl = .fire
    }
    @IBOutlet weak var musicButton: UIButton!
    @IBAction func musicButtonPressed(_ sender: UIButton) {
        activeControl = .music
    }
    
    
}

