//
//  MockAPIService.swift
//  ColorChangeDemoApp
//
//  Created by luminous on 26/11/25.
//

import Foundation
import SwiftUI

protocol APIServiceProtocol {
    func getVehicles() async -> APIResponse<[Vehicle]>
    func updateVehicleColor(name: String, color: String) async -> APIResponse<Vehicle>
}

final class MockAPIService: APIServiceProtocol {
    private let jsonFileService = JSONFileService.shared
    
    // Simulate network delay
    private let delay: TimeInterval = 0.3
    
    // Simulate random errors (set to true to test error scenarios)
    private let simulateErrors = false
    private var requestCount = 0
    
    func getVehicles() async -> APIResponse<[Vehicle]> {
        requestCount += 1
        
        // Simulate network delay
        try? await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
        
        // Simulate different status codes for testing
        if simulateErrors {
            let statusCode = getSimulatedStatusCode(for: requestCount)
            if statusCode != 200 {
                return handleErrorResponse(statusCode: statusCode, operation: "GET")
            }
        }
        
        do {
            // Read from JSON file
            let vehicles = try jsonFileService.loadVehicles()
            
            guard !vehicles.isEmpty else {
                return APIResponse<[Vehicle]>(
                    statusCode: HTTPStatusCode.notFound.rawValue,
                    error: APIError.vehicleNotFound,
                    message: HTTPStatusCode.notFound.statusMessage
                )
            }
            
            print("📡 GET API: Status 200 - Returning \(vehicles.count) vehicles from JSON response")
            
            return APIResponse<[Vehicle]>(
                statusCode: HTTPStatusCode.ok.rawValue,
                data: vehicles,
                message: HTTPStatusCode.ok.statusMessage
            )
        } catch {
            return APIResponse<[Vehicle]>(
                statusCode: HTTPStatusCode.internalServerError.rawValue,
                error: APIError.networkError,
                message: HTTPStatusCode.internalServerError.statusMessage
            )
        }
    }
    
    func updateVehicleColor(name: String, color: String) async -> APIResponse<Vehicle> {
        requestCount += 1
        
        // Simulate network delay
        try? await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
        
        // Simulate different status codes for testing
        if simulateErrors {
            let statusCode = getSimulatedStatusCode(for: requestCount)
            if statusCode != 200 {
                return handleErrorResponse(statusCode: statusCode, operation: "PUT")
            }
        }
        
        do {
            // Load current vehicles from JSON
            var vehicles = try jsonFileService.loadVehicles()
            
            // Find the vehicle
            guard let index = vehicles.firstIndex(where: { $0.name == name }) else {
                return APIResponse<Vehicle>(
                    statusCode: HTTPStatusCode.notFound.rawValue,
                    error: APIError.vehicleNotFound,
                    message: HTTPStatusCode.notFound.statusMessage
                )
            }
            
            // Validate color
            guard Color(colorName: color) != nil else {
                return APIResponse<Vehicle>(
                    statusCode: HTTPStatusCode.badRequest.rawValue,
                    error: APIError.invalidResponse,
                    message: HTTPStatusCode.badRequest.statusMessage + " - Invalid color name"
                )
            }
            
            // Update vehicle
            var updatedVehicle = vehicles[index]
            updatedVehicle.color = color
            vehicles[index] = updatedVehicle
            
            // Save updated vehicles back to JSON file
            try jsonFileService.saveVehicles(vehicles)
            
            print("📝 PUT API: Status 200 - Updated vehicle '\(name)' color to '\(color)' in JSON file")
            
            return APIResponse<Vehicle>(
                statusCode: HTTPStatusCode.ok.rawValue,
                data: updatedVehicle,
                message: HTTPStatusCode.ok.statusMessage
            )
        } catch {
            return APIResponse<Vehicle>(
                statusCode: HTTPStatusCode.internalServerError.rawValue,
                error: APIError.networkError,
                message: HTTPStatusCode.internalServerError.statusMessage
            )
        }
    }
    
    // MARK: - Helper Methods
    
    private func getSimulatedStatusCode(for requestNumber: Int) -> Int {
        // Simulate different error scenarios
        switch requestNumber % 10 {
        case 1:
            return HTTPStatusCode.badRequest.rawValue
        case 2:
            return HTTPStatusCode.unauthorized.rawValue
        case 3:
            return HTTPStatusCode.notFound.rawValue
        case 4:
            return HTTPStatusCode.internalServerError.rawValue
        case 5:
            return HTTPStatusCode.serviceUnavailable.rawValue
        default:
            return HTTPStatusCode.ok.rawValue
        }
    }
    
    private func handleErrorResponse<T>(statusCode: Int, operation: String) -> APIResponse<T> {
        let httpStatus = HTTPStatusCode(rawValue: statusCode) ?? .internalServerError
        let error: APIError
        
        switch statusCode {
        case 400...499:
            error = .invalidResponse
        case 500...599:
            error = .networkError
        default:
            error = .networkError
        }
        
        print("❌ \(operation) API: Status \(statusCode) - \(httpStatus.description)")
        
        return APIResponse<T>(
            statusCode: statusCode,
            error: error,
            message: httpStatus.statusMessage
        )
    }
}

enum APIError: LocalizedError {
    case vehicleNotFound
    case invalidResponse
    case networkError
    
    var errorDescription: String? {
        switch self {
        case .vehicleNotFound:
            return "Vehicle not found"
        case .invalidResponse:
            return "Invalid response from server"
        case .networkError:
            return "Network error occurred"
        }
    }
}
