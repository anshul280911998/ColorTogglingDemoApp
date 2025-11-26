//
//  ColorBox.swift
//  ColorChangeDemoApp
//
//  Created by luminous on 26/11/25.
//

import Foundation
import SwiftUI

struct ColorBox: Equatable {
    let id: UUID
    var color: Color
    
    init(id: UUID = UUID(), color: Color) {
        self.id = id
        self.color = color
    }
}
