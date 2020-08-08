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

    var volume: Float = 0
    var hz: Float = 0

    private let audioEngine = AVAudioEngine()
    private let player = AVAudioPlayerNode()
    private var buffer: AVAudioPCMBuffer!
    private var fadeInBuffer: AVAudioPCMBuffer!
    private var fadeOutBuffer: AVAudioPCMBuffer!

    init(volume: Float = 0.1, hz: Float = 600) {
        self.volume = volume
        self.hz = hz

        buffer = makeBuffer()
        fadeInBuffer = makeBuffer(fade: .in)
        fadeOutBuffer = makeBuffer(fade: .out)

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
        let capacity = fade == .none ? length : 20 * length
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
            let value = power * volume * sinf(Float(n) * 2.0 * Float.pi / Float(length))
            buf.floatChannelData?.advanced(by: 0).pointee[n] = value
            buf.floatChannelData?.advanced(by: 1).pointee[n] = value
        }
        return buf
    }

    func play() {
        if audioEngine.isRunning {
            player.volume = 1.0
            player.scheduleBuffer(fadeInBuffer, at: nil, options: .interrupts, completionHandler: nil)
            player.scheduleBuffer(buffer, at: nil, options: .loops, completionHandler: nil)
            player.play()
        }
    }

    func pause() {
        if player.isPlaying {
            player.scheduleBuffer(fadeOutBuffer, at: nil, options: .interruptsAtLoop, completionHandler: {
                self.player.pause()
            })
            player.play()
        }
    }

    func stop() {
        if player.isPlaying {
            player.scheduleBuffer(fadeOutBuffer, at: nil, options: .interruptsAtLoop, completionHandler: {
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
