//
//  File.swift
//  ColorChangeDemoApp
//
//  Created by luminous on 26/11/25.
//

import Foundation
import SwiftUI

protocol SwapColorsUseCaseProtocol {
    func execute(color1: Color, color2: Color) -> (Color, Color)
}

final class SwapColorsUseCase: SwapColorsUseCaseProtocol {
    private let repository: ColorRepositoryProtocol
    
    init(repository: ColorRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(color1: Color, color2: Color) -> (Color, Color) {
        return repository.swapColors(color1, color2)
    }
}


