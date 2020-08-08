//
//  SineWave.swift
//  SineWaveSound
//
//  Created by Takuto Nakamura on 2020/08/09.
//  Copyright © 2020 Takuto Nakamura. All rights reserved.
//

import AVFoundation

class SineWave {

    private enum Fade {
        case none
        case `in`
        case out
    }

    let audioEngine = AVAudioEngine()
    let player = AVAudioPlayerNode()
    var volume: Float = 0
    var hz: Float = 0

    init(volume: Float = 0.1, hz: Float = 600) {
        self.volume = volume
        self.hz = hz

        let audioFormat = player.outputFormat(forBus: 0)
        audioEngine.attach(player)
        audioEngine.connect(player, to: audioEngine.mainMixerNode, format: audioFormat)
        audioEngine.prepare()
        do {
            try audioEngine.start()
        } catch {
            logput(error.localizedDescription)
        }
    }

    deinit {
        stopEngine()
    }

    private func makeBuffer(fade: Fade = .none) -> AVAudioPCMBuffer {
        let audioFormat = player.outputFormat(forBus: 0)
        let sampleRate = Float(audioFormat.sampleRate) // 44100.0
        let length = AVAudioFrameCount(sampleRate / hz)
        let capacity = fade == .none ? length : 50 * length
        guard let buf = AVAudioPCMBuffer(pcmFormat: audioFormat, frameCapacity: capacity) else {
            fatalError("Error initializing AVAudioPCMBuffer")
        }
        buf.frameLength = capacity
        let u = Float.pi / Float(capacity)
        for n in (0 ..< Int(capacity)) {
            let power: Float
            switch fade {
            case .none: power = 1.0
            case .in:   power = 0.5 * (1.0 - cosf(Float(n) * u))
            case .out:  power = 0.5 * (1.0 + cosf(Float(n) * u))
            }
            let val = sinf(Float(n) * 2.0 * Float.pi / Float(length))
            buf.floatChannelData?.advanced(by: 0).pointee[n] = power * volume * val
            buf.floatChannelData?.advanced(by: 1).pointee[n] = power * volume * val
        }
        return buf
    }

    func play() {
        if audioEngine.isRunning {
            player.stop()
            player.volume = 1.0
            player.scheduleBuffer(makeBuffer(fade: .in), completionHandler: nil)
            player.scheduleBuffer(makeBuffer(), at: nil, options: .loops, completionHandler: nil)
            player.play()
        }
    }

    func pause() {
        if player.isPlaying {
            player.scheduleBuffer(makeBuffer(fade: .out), at: nil, options: .interruptsAtLoop, completionHandler: {
                self.player.pause()
            })
            player.play()
        }
    }

    func stop() {
        if player.isPlaying {
            player.scheduleBuffer(makeBuffer(fade: .out), at: nil, options: .interruptsAtLoop, completionHandler: {
                self.player.stop()
            })
            player.play()
        }
    }

    func stopEngine() {
        stop()
        if audioEngine.isRunning {
            audioEngine.stop()
        }
    }

}
