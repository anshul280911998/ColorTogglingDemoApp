//
//  VehiclesResponse.swift
//  ColorChangeDemoApp
//
//  Created by luminous on 26/11/25.
//


import Foundation

struct VehiclesResponse: Codable {
    let vehicles: [Vehicle]
}

struct VehicleUpdateRequest: Codable {
    let name: String
    let color: String
}

struct VehicleUpdateResponse: Codable {
    let success: Bool
    let vehicle: Vehicle
}

struct SwapVehiclesResponse: Codable {
    let vehicle1: Vehicle
    let vehicle2: Vehicle
    
    var tuple: (Vehicle, Vehicle) {
        return (vehicle1, vehicle2)
    }
    
    init(vehicle1: Vehicle, vehicle2: Vehicle) {
        self.vehicle1 = vehicle1
        self.vehicle2 = vehicle2
    }
    
    init(tuple: (Vehicle, Vehicle)) {
        self.vehicle1 = tuple.0
        self.vehicle2 = tuple.1
    }
}

