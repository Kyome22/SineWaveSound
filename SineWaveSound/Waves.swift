//
//  Waves.swift
//  SineWaveSound
//
//  Created by Takuto Nakamura on 2021/06/30.
//

import SwiftUI

struct WavesShape: Shape {
    @Binding var array: [Bool] // 101
    
    func path(in rect: CGRect) -> Path {
        let xUnit: CGFloat = rect.width / 100
        let yUnit: CGFloat = rect.height / 3
        
        var path = Path()
        for i in (0 ..< array.count) {
            if i == 0 {
                path.move(to: CGPoint(x: 0, y: array[i].k * yUnit))
            } else {
                if array[i - 1] != array[i] {
                    path.addLine(to: CGPoint(x: CGFloat(i) * xUnit, y: array[i - 1].k * yUnit))
                }
                path.addLine(to: CGPoint(x: CGFloat(i) * xUnit, y: array[i].k * yUnit))
            }
        }
        return path
    }
}

extension Bool {
    var k: CGFloat {
        return self ? 1 : 2
    }
}

struct Waves: View {
    @Binding var touching: Bool
    @State var array = [Bool](repeating: false, count: 101)
    
    let timer = Timer.publish(every: 0.02, on: .main, in: .common).autoconnect()
    
    var body: some View {
        WavesShape(array: $array)
            .stroke(Color.blue, lineWidth: 2.0)
            .onReceive(timer, perform: { _ in
                array.removeFirst()
                array.append(touching)
            })
    }
}
