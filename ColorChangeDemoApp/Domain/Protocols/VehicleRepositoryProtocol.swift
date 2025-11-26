//
//  VehiclesRepositoryProtocol.swift
//  ColorChangeDemoApp
//
//  Created by luminous on 26/11/25.
//


import Foundation
import SwiftUI

protocol VehicleRepositoryProtocol {
    func getVehicles() async -> APIResponse<[Vehicle]>
    func updateVehicleColor(name: String, color: Color) async -> APIResponse<Vehicle>
    func swapVehicleColors(vehicle1: Vehicle, vehicle2: Vehicle) async -> APIResponse<SwapVehiclesResponse>
}

