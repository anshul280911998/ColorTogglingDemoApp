//
//  ColorRepository.swift
//  ColorChangeDemoApp
//
//  Created by luminous on 26/11/25.
//

import Foundation
import SwiftUI

final class ColorRepository: ColorRepositoryProtocol {
    func getInitialColors() -> (Color, Color) {
        return (Color.blue, Color.red)
    }
    
    func swapColors(_ color1: Color, _ color2: Color) -> (Color, Color) {
        return (color2, color1)
    }
}


