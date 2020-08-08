//
//  Extensions.swift
//  SineWaveSound
//
//  Created by Takuto Nakamura on 2020/08/09.
//  Copyright © 2020 Takuto Nakamura. All rights reserved.
//

import Foundation

func logput(_ item: Any..., file: String = #file, line: Int = #line, function: String = #function) {
    #if DEBUG
    let fileName = URL(fileURLWithPath: file).lastPathComponent
    Swift.print("Log: \(fileName), Line:\(line), \(function)", item)
    #endif
}
