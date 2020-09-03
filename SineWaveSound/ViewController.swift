//
//  ViewController.swift
//  SineWaveSound
//
//  Created by Takuto Nakamura on 2020/08/09.
//  Copyright © 2020 Takuto Nakamura. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    @IBOutlet weak var samplerButton: SoundButton!
    @IBOutlet weak var sineWaveButton: SoundButton!
    @IBOutlet weak var volumeSlider: NSSlider!
    @IBOutlet weak var volumeLabel: NSTextField!
    @IBOutlet weak var hzSlider: NSSlider!
    @IBOutlet weak var hzLabel: NSTextField!

    var sampler: Sampler?
    var sineWave: SineWave?

    override func viewDidLoad() {
        super.viewDidLoad()

        sampler = Sampler()
        sineWave = SineWave(volume: 0.1)

        samplerButton.pushHandler = { [weak self] isPush in
            self?.pushSampler(isPush: isPush)
        }
        sineWaveButton.pushHandler = { [weak self] isPush in
            self?.pushSineWave(isPush: isPush)
        }

        setUI()
    }

    func setUI() {
        samplerButton.title = "Sampler"
        sineWaveButton.title = "Size Wave"

        volumeSlider.minValue = 0.0
        volumeSlider.maxValue = 1.0
        volumeSlider.floatValue = 0.1
        volumeLabel.stringValue = "0.1"

        hzSlider.minValue = 0
        hzSlider.maxValue = 12
        hzSlider.integerValue = 4
        hzLabel.stringValue = "600.0"
    }

    @IBAction func changeVolume(_ sender: NSSlider) {
        let value = sender.floatValue
        sineWave?.volume = value
        volumeLabel.stringValue = String(format: "%.2f", value)
    }

    @IBAction func changeHz(_ sender: NSSlider) {
        let value = Float(400 + 50 * sender.integerValue)
        sender.floatValue = Float(sender.integerValue)
        sineWave?.hz = value
        hzLabel.stringValue = String(format: "%.1f", value)
    }

    func pushSampler(isPush: Bool) {
        if isPush {
            sampler?.play()
        } else {
            sampler?.stop()
        }
    }

    func pushSineWave(isPush: Bool) {
        if isPush {
            sineWave?.play()
        } else {
            sineWave?.pause()
        }
    }
}

