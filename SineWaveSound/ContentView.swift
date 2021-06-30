//
//  ContentView.swift
//  SineWaveSound
//
//  Created by Takuto Nakamura on 2021/06/28.
//

import SwiftUI

struct ContentView: View {
    @State var isTouching: Bool = false
    @State var currentVolume: Float = 0.1
    @State var currentHz: Float = 600
    
    let sinewave = SineWave()
    let rect = CGRect(origin: .zero, size: CGSize(width: 240, height: 160))
    
    var body: some View {
        VStack {
            Waves(touching: $isTouching)
                .frame(height: 45)
                .padding(.bottom, 30)
            Text("Play Sine Wave")
                .font(.title)
                .fontWeight(.bold)
                .frame(width: rect.width, height: rect.height)
                .foregroundColor(isTouching ? Color.gray : Color.white)
                .background(Color.blue)
                .opacity(isTouching ? 0.8 : 1.0)
                .clipShape(SuperEllipseShape(rate: 0.75))
                .gesture(drag)
                .padding(.bottom, 50)
            Text("Volume: \(currentVolume, specifier: "%0.1f")")
            Slider(value:  $currentVolume,
                   in: 0.0 ... 1.0,
                   step: 0.1,
                   onEditingChanged: changedVolume,
                   minimumValueLabel: MonoText("0.1"),
                   maximumValueLabel: MonoText("1.0"),
                   label: { EmptyView() })
                .padding(.bottom, 20)
            Text("Hz: \(Int(currentHz), specifier: "%d")")
            Slider(value: $currentHz,
                   in: 400 ... 990,
                   step: 10,
                   onEditingChanged: changedHz,
                   minimumValueLabel: MonoText("400"),
                   maximumValueLabel: MonoText("990"),
                   label: { EmptyView() })
        }
        .padding(20)
    }
    
    var drag: some Gesture {
        DragGesture(minimumDistance: 0.0)
            .onChanged({ drag in
                if rect.contains(drag.location) {
                    if !isTouching {
                        sinewave.play()
                        isTouching = true
                    }
                } else if isTouching {
                    sinewave.pause()
                    isTouching = false
                }
            })
            .onEnded({ _ in
                if isTouching {
                    sinewave.pause()
                    isTouching = false
                }
            })
    }
    
    func MonoText(_ label: String) -> Text {
        Text(label).font(.system(.body, design: .monospaced))
    }
    
    func changedVolume(_ editing: Bool) -> Void {
        if !editing {
            sinewave.volume = currentVolume
        }
    }
    
    func changedHz(_ editing: Bool) -> Void {
        if !editing {
            self.sinewave.hz = currentHz
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
