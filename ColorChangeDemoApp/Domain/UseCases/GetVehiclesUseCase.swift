//
//  GetVehiclesUseCase.swift
//  ColorChangeDemoApp
//
//  Created by luminous on 26/11/25.
//

import Foundation

protocol GetVehiclesUseCaseProtocol {
    func execute() async -> APIResponse<[Vehicle]>
}

final class GetVehiclesUseCase: GetVehiclesUseCaseProtocol {
    private let repository: VehicleRepositoryProtocol
    
    init(repository: VehicleRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute() async -> APIResponse<[Vehicle]> {
        return await repository.getVehicles()
    }
}
