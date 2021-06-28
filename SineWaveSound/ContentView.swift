//
//  ContentView.swift
//  SineWaveSound
//
//  Created by Takuto Nakamura on 2021/06/28.
//

import SwiftUI

struct ContentView: View {
    @State var isDragging: Bool = false
    @State var currentVolume: Float = 0.1
    @State var currentHz: Float = 600
    
    let sinewave = SineWave()
    
    var body: some View {
        VStack {
            Text("Play Sine Wave")
                .frame(width: 200, height: 50)
                .foregroundColor(isDragging ? Color.gray : Color.white)
                .background(Color.blue)
                .cornerRadius(25)
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
                   in: 400 ... 950,
                   step: 50,
                   onEditingChanged: changedHz,
                   minimumValueLabel: MonoText("400"),
                   maximumValueLabel: MonoText("950")) {
                EmptyView()
            }
        }
        .padding(20)
    }
    
    var drag: some Gesture {
        DragGesture(minimumDistance: 0.0)
            .onChanged({ drag in
                if !isDragging {
                    sinewave.play()
                }
                isDragging = true
            })
            .onEnded({ _ in
                if isDragging {
                    sinewave.pause()
                }
                isDragging = false
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
