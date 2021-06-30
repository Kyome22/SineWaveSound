//
//  SuperEllipseShape.swift
//  SineWaveSound
//
//  Created by Takuto Nakamura on 2021/06/30.
//

import SwiftUI

struct SuperEllipseShape: Shape {
    let rate: CGFloat
    func path(in rect: CGRect) -> Path {
        let handleX: CGFloat = 0.5 * rate * rect.width
        let handleY: CGFloat = 0.5 * rate * rect.height
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.midY))
        path.addCurve(to: CGPoint(x: rect.midX, y: rect.minY),
                      control1: CGPoint(x: rect.minX, y: rect.midY - handleY),
                      control2: CGPoint(x: rect.midX - handleX, y: rect.minY))
        
        path.addCurve(to: CGPoint(x: rect.maxX, y: rect.midY),
                      control1: CGPoint(x: rect.midX + handleX, y: rect.minY),
                      control2: CGPoint(x: rect.maxX, y: rect.midY - handleY))
        
        path.addCurve(to: CGPoint(x: rect.midX, y: rect.maxY),
                      control1: CGPoint(x: rect.maxX, y: rect.midY + handleY),
                      control2: CGPoint(x: rect.midX + handleX, y: rect.maxY))
        
        path.addCurve(to: CGPoint(x: rect.minX, y: rect.midY),
                      control1: CGPoint(x: rect.midX - handleX, y: rect.maxY),
                      control2: CGPoint(x: rect.minX, y: rect.midY + handleY))
        return path
    }
}
