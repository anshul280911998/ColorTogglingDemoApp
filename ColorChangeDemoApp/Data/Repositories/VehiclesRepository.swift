//
//  VehiclesRepository.swift
//  ColorChangeDemoApp
//
//  Created by luminous on 26/11/25.
//

import Foundation
import SwiftUI

final class VehicleRepository: VehicleRepositoryProtocol {
    private let apiService: APIServiceProtocol
    
    init(apiService: APIServiceProtocol) {
        self.apiService = apiService
    }
    
    func getVehicles() async -> APIResponse<[Vehicle]> {
        return await apiService.getVehicles()
    }
    
    func updateVehicleColor(name: String, color: Color) async -> APIResponse<Vehicle> {
        guard let colorName = color.toColorName() else {
            return APIResponse<Vehicle>(
                statusCode: HTTPStatusCode.badRequest.rawValue,
                error: APIError.invalidResponse,
                message: HTTPStatusCode.badRequest.statusMessage + " - Invalid color"
            )
        }
        return await apiService.updateVehicleColor(name: name, color: colorName)
    }
    
    func swapVehicleColors(vehicle1: Vehicle, vehicle2: Vehicle) async -> APIResponse<SwapVehiclesResponse> {
        let color1 = vehicle1.swiftUIColor
        let color2 = vehicle2.swiftUIColor
        
        let response1 = await updateVehicleColor(name: vehicle1.name, color: color2)
        guard response1.isSuccess, let updatedVehicle1 = response1.data else {
            return APIResponse<SwapVehiclesResponse>(
                statusCode: response1.statusCode,
                error: response1.error,
                message: response1.message
            )
        }
        
        let response2 = await updateVehicleColor(name: vehicle2.name, color: color1)
        guard response2.isSuccess, let updatedVehicle2 = response2.data else {
            return APIResponse<SwapVehiclesResponse>(
                statusCode: response2.statusCode,
                error: response2.error,
                message: response2.message
            )
        }
        
        let swapResponse = SwapVehiclesResponse(vehicle1: updatedVehicle1, vehicle2: updatedVehicle2)
        
        return APIResponse<SwapVehiclesResponse>(
            statusCode: HTTPStatusCode.ok.rawValue,
            data: swapResponse,
            message: HTTPStatusCode.ok.statusMessage
        )
    }
}
