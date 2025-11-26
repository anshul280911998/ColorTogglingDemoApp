//
//  DependencyContainer.swift
//  ColorChangeDemoApp
//
//  Created by luminous on 26/11/25.
//

import Foundation
import SwiftUI

final class DependencyContainer {
    // MARK: - Services
    lazy var apiService: APIServiceProtocol = {
        MockAPIService()
    }()
    
    // MARK: - Repositories
    lazy var vehicleRepository: VehicleRepositoryProtocol = {
        VehicleRepository(apiService: apiService)
    }()
    
    // MARK: - Use Cases
    lazy var getVehiclesUseCase: GetVehiclesUseCaseProtocol = {
        GetVehiclesUseCase(repository: vehicleRepository)
    }()
    
    lazy var swapVehicleColorsUseCase: SwapVehicleColorsUseCaseProtocol = {
        SwapVehicleColorsUseCase(repository: vehicleRepository)
    }()
    
    // MARK: - View Models
    @MainActor
    func makeColorTogglingViewModel() -> ColorTogglingViewModel {
        ColorTogglingViewModel(
            getVehiclesUseCase: getVehiclesUseCase,
            swapVehicleColorsUseCase: swapVehicleColorsUseCase
        )
    }
}

