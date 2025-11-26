//
//  VehiclesRepositoryTests.swift
//  ColorChangeDemoAppTests
//
//  Created by luminous on 26/11/25.
//

import XCTest
import SwiftUI
@testable import ColorChangeDemoApp

final class VehiclesRepositoryTests: XCTestCase {
    
    var repository: VehicleRepository!
    var mockAPIService: MockAPIService!
    
    override func setUp() {
        super.setUp()
        mockAPIService = MockAPIService()
        repository = VehicleRepository(apiService: mockAPIService)
    }
    
    override func tearDown() {
        repository = nil
        mockAPIService = nil
        super.tearDown()
    }
    
    // MARK: - Get Vehicles Tests
    
    func testGetVehicles_Success() async {
        // Given
        let vehicles = [
            Vehicle(name: "car", color: "red"),
            Vehicle(name: "truck", color: "blue")
        ]
        mockAPIService.getVehiclesResponse = APIResponse(
            statusCode: 200,
            data: vehicles,
            message: "Success"
        )
        
        // When
        let result = await repository.getVehicles()
        
        // Then
        XCTAssertTrue(result.isSuccess)
        XCTAssertEqual(result.statusCode, 200)
        XCTAssertNotNil(result.data)
        XCTAssertEqual(result.data?.count, 2)
    }
    
    // MARK: - Update Vehicle Color Tests
    
    func testUpdateVehicleColor_Success() async {
        // Given
        let updatedVehicle = Vehicle(name: "car", color: "blue")
        mockAPIService.updateVehicleColorResponse = APIResponse(
            statusCode: 200,
            data: updatedVehicle,
            message: "Success"
        )
        
        // When
        let result = await repository.updateVehicleColor(name: "car", color: .blue)
        
        // Then
        XCTAssertTrue(result.isSuccess)
        XCTAssertEqual(result.statusCode, 200)
        XCTAssertNotNil(result.data)
        XCTAssertEqual(result.data?.color, "blue")
    }
    
    func testUpdateVehicleColor_InvalidColor() async {
        // Given - using a custom color that can't be converted to name
        let customColor = Color(red: 0.5, green: 0.3, blue: 0.7)
        
        // When
        let result = await repository.updateVehicleColor(name: "car", color: customColor)
        
        // Then
        XCTAssertFalse(result.isSuccess)
        XCTAssertEqual(result.statusCode, 400)
        XCTAssertNil(result.data)
        XCTAssertNotNil(result.error)
    }
    
    // MARK: - Swap Vehicle Colors Tests
    
    func testSwapVehicleColors_Success() async {
        // Given
        let vehicle1 = Vehicle(name: "car", color: "red")
        let vehicle2 = Vehicle(name: "truck", color: "blue")
        
        let updatedVehicle1 = Vehicle(name: "car", color: "blue")
        let updatedVehicle2 = Vehicle(name: "truck", color: "red")
        
        mockAPIService.updateVehicleColorResponse = APIResponse(
            statusCode: 200,
            data: updatedVehicle1,
            message: "Success"
        )
        
        // When
        let result = await repository.swapVehicleColors(vehicle1: vehicle1, vehicle2: vehicle2)
        
        // Then
        XCTAssertTrue(result.isSuccess)
        XCTAssertEqual(result.statusCode, 200)
        XCTAssertNotNil(result.data)
        // Note: The actual swap logic updates both vehicles, so we verify the structure
    }
    
    func testSwapVehicleColors_FirstUpdateFails() async {
        // Given
        let vehicle1 = Vehicle(name: "car", color: "red")
        let vehicle2 = Vehicle(name: "truck", color: "blue")
        
        mockAPIService.updateVehicleColorResponse = APIResponse<Vehicle>(
            statusCode: 500,
            error: APIError.networkError,
            message: "Internal Server Error"
        )
        
        // When
        let result = await repository.swapVehicleColors(vehicle1: vehicle1, vehicle2: vehicle2)
        
        // Then
        XCTAssertFalse(result.isSuccess)
        XCTAssertEqual(result.statusCode, 500)
        XCTAssertNil(result.data)
    }
    
    func testSwapVehicleColors_SecondUpdateFails() async {
        // Given
        let vehicle1 = Vehicle(name: "car", color: "red")
        let vehicle2 = Vehicle(name: "truck", color: "blue")
        
        // First call succeeds
        let updatedVehicle1 = Vehicle(name: "car", color: "blue")
        mockAPIService.updateVehicleColorResponse = APIResponse(
            statusCode: 200,
            data: updatedVehicle1,
            message: "Success"
        )
        
        // Second call fails - we need to track call count
        var callCount = 0
        mockAPIService.updateVehicleColorHandler = { name, color in
            callCount += 1
            if callCount == 1 {
                return APIResponse(
                    statusCode: 200,
                    data: updatedVehicle1,
                    message: "Success"
                )
            } else {
                return APIResponse<Vehicle>(
                    statusCode: 500,
                    error: APIError.networkError,
                    message: "Internal Server Error"
                )
            }
        }
        
        // When
        let result = await repository.swapVehicleColors(vehicle1: vehicle1, vehicle2: vehicle2)
        
        // Then
        XCTAssertFalse(result.isSuccess)
        XCTAssertEqual(result.statusCode, 500)
    }
}

// MARK: - Mock API Service

class MockAPIService: APIServiceProtocol {
    var getVehiclesResponse: APIResponse<[Vehicle]> = APIResponse(
        statusCode: 200,
        data: [],
        message: "Success"
    )
    
    var updateVehicleColorResponse: APIResponse<Vehicle> = APIResponse(
        statusCode: 200,
        data: Vehicle(name: "car", color: "red"),
        message: "Success"
    )
    
    var updateVehicleColorHandler: ((String, String) -> APIResponse<Vehicle>)?
    
    func getVehicles() async -> APIResponse<[Vehicle]> {
        return getVehiclesResponse
    }
    
    func updateVehicleColor(name: String, color: String) async -> APIResponse<Vehicle> {
        if let handler = updateVehicleColorHandler {
            return handler(name, color)
        }
        return updateVehicleColorResponse
    }
}

