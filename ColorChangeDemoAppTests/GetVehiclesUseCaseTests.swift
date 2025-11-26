//
//  GetVehiclesUseCaseTests.swift
//  ColorChangeDemoAppTests
//
//  Created by luminous on 26/11/25.
//

import XCTest
import SwiftUI
@testable import ColorChangeDemoApp

final class GetVehiclesUseCaseTests: XCTestCase {
    
    var useCase: GetVehiclesUseCase!
    var mockRepository: MockVehicleRepository!
    
    override func setUp() {
        super.setUp()
        mockRepository = MockVehicleRepository()
        useCase = GetVehiclesUseCase(repository: mockRepository)
    }
    
    override func tearDown() {
        useCase = nil
        mockRepository = nil
        super.tearDown()
    }
    
    func testExecute_Success() async {
        // Given
        let vehicles = [
            Vehicle(name: "car", color: "red"),
            Vehicle(name: "truck", color: "blue")
        ]
        mockRepository.getVehiclesResponse = APIResponse(
            statusCode: 200,
            data: vehicles,
            message: "Success"
        )
        
        // When
        let result = await useCase.execute()
        
        // Then
        XCTAssertTrue(result.isSuccess)
        XCTAssertEqual(result.statusCode, 200)
        XCTAssertNotNil(result.data)
        XCTAssertEqual(result.data?.count, 2)
        XCTAssertEqual(result.data?.first?.name, "car")
        XCTAssertEqual(result.data?.first?.color, "red")
    }
    
    func testExecute_Failure() async {
        // Given
        mockRepository.getVehiclesResponse = APIResponse<[Vehicle]>(
            statusCode: 500,
            error: APIError.networkError,
            message: "Internal Server Error"
        )
        
        // When
        let result = await useCase.execute()
        
        // Then
        XCTAssertFalse(result.isSuccess)
        XCTAssertEqual(result.statusCode, 500)
        XCTAssertNil(result.data)
        XCTAssertNotNil(result.error)
        XCTAssertEqual(result.message, "Internal Server Error")
    }
    
    func testExecute_CallsRepository() async {
        // Given
        mockRepository.getVehiclesResponse = APIResponse(
            statusCode: 200,
            data: [],
            message: "Success"
        )
        
        // When
        _ = await useCase.execute()
        
        // Then
        XCTAssertTrue(mockRepository.getVehiclesCalled)
    }
}

// MARK: - Mock Repository

class MockVehicleRepository: VehicleRepositoryProtocol {
    var getVehiclesResponse: APIResponse<[Vehicle]> = APIResponse(
        statusCode: 200,
        data: [],
        message: "Success"
    )
    var getVehiclesCalled = false
    
    var updateVehicleColorResponse: APIResponse<Vehicle> = APIResponse(
        statusCode: 200,
        data: Vehicle(name: "car", color: "red"),
        message: "Success"
    )
    var updateVehicleColorCalled = false
    
    var swapVehicleColorsResponse: APIResponse<SwapVehiclesResponse> = APIResponse(
        statusCode: 200,
        data: SwapVehiclesResponse(
            vehicle1: Vehicle(name: "car", color: "blue"),
            vehicle2: Vehicle(name: "truck", color: "red")
        ),
        message: "Success"
    )
    var swapVehicleColorsCalled = false
    
    func getVehicles() async -> APIResponse<[Vehicle]> {
        getVehiclesCalled = true
        return getVehiclesResponse
    }
    
    func updateVehicleColor(name: String, color: SwiftUI.Color) async -> APIResponse<Vehicle> {
        updateVehicleColorCalled = true
        return updateVehicleColorResponse
    }
    
    func swapVehicleColors(vehicle1: Vehicle, vehicle2: Vehicle) async -> APIResponse<SwapVehiclesResponse> {
        swapVehicleColorsCalled = true
        return swapVehicleColorsResponse
    }
}

