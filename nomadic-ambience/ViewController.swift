//
//  ViewController.swift
//  nomadic-ambience
//
//  Created by Rob Broadwell on 1/8/18.
//  Copyright © 2018 Rob Broadwell. All rights reserved.
//

import UIKit
import AVFoundation

enum Control {
    case storm
    case fire
    case music
}

class ViewController: UIViewController, Reviewable {
    
    var knob: Knob!
    
    let active = UIColor.init(red: 255/255, green: 229/255, blue: 255/255, alpha: 1)
    let inactive = UIColor.init(red: 83/255, green: 83/255, blue: 83/255, alpha: 1)

    @IBOutlet weak var knobPlaceholder: UIView!
    
    var activeControl: Control = Control.fire {
        didSet {
            updateUI()
        }
    }
    
    var playing: Bool = true {
        didSet {
            updateUI()
        }
    }
    
    var stormVolume: Float = 0.5 {
        didSet {
            stormPlayer?.volume = stormVolume
        }
    }
    
    var fireVolume: Float = 0.5 {
        didSet {
            firePlayer?.volume = fireVolume
        }
    }
    
    var musicVolume: Float = 0.5 {
        didSet {
            musicPlayer?.volume = musicVolume
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.tintColor = UIColor.init(red: 255/255, green: 229/255, blue: 255/255, alpha: 1)
        
        knob = Knob(frame: knobPlaceholder.bounds)
        knob.addTarget(self, action: #selector(knobValueChanged(knob:)), for: .allEvents)
        knob.isUserInteractionEnabled = true
        knobPlaceholder.addSubview(knob)
        
        stormButton.imageView?.contentMode = .scaleAspectFit
        fireButton.imageView?.contentMode = .scaleAspectFit
        musicButton.imageView?.contentMode = .scaleAspectFit
        playButton.imageView?.contentMode = .scaleAspectFit
        
        updateUI()
        playAll()
        
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
//            self.review()
//        }
        
    }
    
    func updateUI() {
        switch activeControl {
            
        case Control.storm:
            stormButton.tintColor = active
            fireButton.tintColor = inactive
            musicButton.tintColor = inactive
            knob.value = stormVolume
            
        case Control.fire:
            stormButton.tintColor = inactive
            fireButton.tintColor = active
            musicButton.tintColor = inactive
            knob.value = fireVolume
            
        case Control.music:
            stormButton.tintColor = inactive
            fireButton.tintColor = inactive
            musicButton.tintColor = active
            knob.value = musicVolume
        }
        
        if playing {
            playButton.tintColor = active
        } else {
            playButton.tintColor = inactive
        }
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
    
    var stormPlayer: AVAudioPlayer?
    @IBOutlet weak var stormButton: UIButton!
    @IBAction func stormButtonPressed(_ sender: UIButton) {
        activeControl = .storm
    }
    
    var firePlayer: AVAudioPlayer?
    @IBOutlet weak var fireButton: UIButton!
    @IBAction func fireButtonPressed(_ sender: UIButton) {
        activeControl = .fire
    }
    
    var musicPlayer: AVAudioPlayer?
    @IBOutlet weak var musicButton: UIButton!
    @IBAction func musicButtonPressed(_ sender: UIButton) {
        activeControl = .music
    }
    
    @IBOutlet weak var playButton: UIButton!
    @IBAction func playButtonPressed(_ sender: UIButton) {
        playing = !playing
        if playing {
            playAll()
        } else {
            stopAll()
        }
    }
    
    func playAll() {
        guard let storm = stormPlayer,
            let fire = firePlayer,
            let music = musicPlayer else { startAll(); return }
        
        storm.play()
        fire.play()
        music.play()
    }
    
    func stopAll() {
        guard let storm = stormPlayer,
            let fire = firePlayer,
            let music = musicPlayer else { return }
        
        storm.pause()
        fire.pause()
        music.pause()
    }
    
    func startAll() {
        playStorm()
        playFire()
        playMusic()
    }
    
    func playStorm() {
        guard let url = Bundle.main.url(forResource: "storm", withExtension: "mp3") else { return }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, with: AVAudioSessionCategoryOptions.mixWithOthers)
            try AVAudioSession.sharedInstance().setActive(true)
            
            stormPlayer = try AVAudioPlayer(contentsOf: url)
            guard let player = stormPlayer else { return }
            
            player.numberOfLoops = -1
            player.play()
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func playFire() {
        guard let url = Bundle.main.url(forResource: "fire", withExtension: "mp3") else { return }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, with: AVAudioSessionCategoryOptions.mixWithOthers)
            try AVAudioSession.sharedInstance().setActive(true)
            
            firePlayer = try AVAudioPlayer(contentsOf: url)
            guard let player = firePlayer else { return }
            
            player.numberOfLoops = -1
            player.play()
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func playMusic() {
        guard let url = Bundle.main.url(forResource: "music", withExtension: "mp3") else { return }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, with: AVAudioSessionCategoryOptions.mixWithOthers)
            try AVAudioSession.sharedInstance().setActive(true)
            
            musicPlayer = try AVAudioPlayer(contentsOf: url)
            guard let player = musicPlayer else { return }
            
            player.numberOfLoops = -1
            player.play()
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
}

