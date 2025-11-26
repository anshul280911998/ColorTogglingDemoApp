//
//  SwapVehicleColorsUseCase.swift
//  ColorChangeDemoApp
//
//  Created by luminous on 26/11/25.
//

import Foundation

protocol SwapVehicleColorsUseCaseProtocol {
    func execute(vehicle1: Vehicle, vehicle2: Vehicle) async -> APIResponse<SwapVehiclesResponse>
}

final class SwapVehicleColorsUseCase: SwapVehicleColorsUseCaseProtocol {
    private let repository: VehicleRepositoryProtocol
    
    init(repository: VehicleRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(vehicle1: Vehicle, vehicle2: Vehicle) async -> APIResponse<SwapVehiclesResponse> {
        return await repository.swapVehicleColors(vehicle1: vehicle1, vehicle2: vehicle2)
    }
}
