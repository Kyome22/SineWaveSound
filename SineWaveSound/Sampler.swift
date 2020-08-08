//
//  SampleSound.swift
//  SineWaveSound
//
//  Created by Takuto Nakamura on 2020/08/09.
//  Copyright © 2020 Takuto Nakamura. All rights reserved.
//

import AVFoundation

class Sampler {

    let engine: AVAudioEngine
    let unitSampler: AVAudioUnitSampler

    init() {
        engine = AVAudioEngine()
        unitSampler = AVAudioUnitSampler()
        engine.attach(unitSampler)
        engine.connect(unitSampler, to: engine.mainMixerNode, format: nil)
        try? engine.start()
    }

    deinit {
        if engine.isRunning {
            engine.disconnectNodeOutput(unitSampler)
            engine.detach(unitSampler)
            engine.stop()
        }
    }

    func play() {
        unitSampler.startNote(67, withVelocity: 80, onChannel: 0)
    }

    func stop() {
        unitSampler.stopNote(67, onChannel: 0)
    }
}
