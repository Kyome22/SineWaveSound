//
//  SoundButton.swift
//  SineWaveSound
//
//  Created by Takuto Nakamura on 2020/08/09.
//  Copyright © 2020 Takuto Nakamura. All rights reserved.
//

import Cocoa

class SoundButton: NSView {

    var title: NSString = "Push me"
    var isPush: Bool = false
    var pushHandler: ((_ isPush: Bool) -> Void)?

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        let rect = NSBezierPath(roundedRect: dirtyRect, xRadius: 8, yRadius: 8)
        if isPush {
            NSColor.orange.setFill()
        } else {
            NSColor.gray.setFill()
        }
        rect.fill()

        let size = title.size(withAttributes: nil)
        let point = NSPoint(x: 0.5 * (self.bounds.width - size.width),
                            y: 0.5 * (self.bounds.height - size.height))
        let attr: [NSAttributedString.Key: Any] = [.foregroundColor: NSColor.white]
        title.draw(at: point, withAttributes: attr)
    }

    override func mouseDown(with event: NSEvent) {
        isPush = true
        self.needsDisplay = true
        pushHandler?(isPush)
    }

    override func mouseUp(with event: NSEvent) {
        isPush = false
        self.needsDisplay = true
        pushHandler?(isPush)
    }

}
