//
//  ColorRepositoryProtocol.swift
//  ColorChangeDemoApp
//
//  Created by luminous on 26/11/25.
//

import Foundation
import SwiftUI

protocol ColorRepositoryProtocol {
    func getInitialColors() -> (Color, Color)
    func swapColors(_ color1: Color, _ color2: Color) -> (Color, Color)
}


