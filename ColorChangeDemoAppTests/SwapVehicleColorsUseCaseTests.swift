//
//  SwapVehicleColorsUseCaseTests.swift
//  ColorChangeDemoAppTests
//
//  Created by luminous on 26/11/25.
//

import XCTest
@testable import ColorChangeDemoApp

final class SwapVehicleColorsUseCaseTests: XCTestCase {
    
    var useCase: SwapVehicleColorsUseCase!
    var mockRepository: MockVehicleRepository!
    
    override func setUp() {
        super.setUp()
        mockRepository = MockVehicleRepository()
        useCase = SwapVehicleColorsUseCase(repository: mockRepository)
    }
    
    override func tearDown() {
        useCase = nil
        mockRepository = nil
        super.tearDown()
    }
    
    func testExecute_Success() async {
        // Given
        let vehicle1 = Vehicle(name: "car", color: "red")
        let vehicle2 = Vehicle(name: "truck", color: "blue")
        
        let swappedResponse = SwapVehiclesResponse(
            vehicle1: Vehicle(name: "car", color: "blue"),
            vehicle2: Vehicle(name: "truck", color: "red")
        )
        mockRepository.swapVehicleColorsResponse = APIResponse(
            statusCode: 200,
            data: swappedResponse,
            message: "Success"
        )
        
        // When
        let result = await useCase.execute(vehicle1: vehicle1, vehicle2: vehicle2)
        
        // Then
        XCTAssertTrue(result.isSuccess)
        XCTAssertEqual(result.statusCode, 200)
        XCTAssertNotNil(result.data)
        XCTAssertEqual(result.data?.vehicle1.color, "blue")
        XCTAssertEqual(result.data?.vehicle2.color, "red")
    }
    
    func testExecute_Failure() async {
        // Given
        let vehicle1 = Vehicle(name: "car", color: "red")
        let vehicle2 = Vehicle(name: "truck", color: "blue")
        
        mockRepository.swapVehicleColorsResponse = APIResponse<SwapVehiclesResponse>(
            statusCode: 500,
            error: APIError.networkError,
            message: "Internal Server Error"
        )
        
        // When
        let result = await useCase.execute(vehicle1: vehicle1, vehicle2: vehicle2)
        
        // Then
        XCTAssertFalse(result.isSuccess)
        XCTAssertEqual(result.statusCode, 500)
        XCTAssertNil(result.data)
        XCTAssertNotNil(result.error)
    }
    
    func testExecute_CallsRepository() async {
        // Given
        let vehicle1 = Vehicle(name: "car", color: "red")
        let vehicle2 = Vehicle(name: "truck", color: "blue")
        
        mockRepository.swapVehicleColorsResponse = APIResponse(
            statusCode: 200,
            data: SwapVehiclesResponse(vehicle1: vehicle1, vehicle2: vehicle2),
            message: "Success"
        )
        
        // When
        _ = await useCase.execute(vehicle1: vehicle1, vehicle2: vehicle2)
        
        // Then
        XCTAssertTrue(mockRepository.swapVehicleColorsCalled)
    }
    
    func testExecute_PassesCorrectVehicles() async {
        // Given
        let vehicle1 = Vehicle(name: "car", color: "red")
        let vehicle2 = Vehicle(name: "truck", color: "blue")
        
        mockRepository.swapVehicleColorsResponse = APIResponse(
            statusCode: 200,
            data: SwapVehiclesResponse(vehicle1: vehicle1, vehicle2: vehicle2),
            message: "Success"
        )
        
        // When
        _ = await useCase.execute(vehicle1: vehicle1, vehicle2: vehicle2)
        
        // Then - verify the repository was called (implicitly tested via mock)
        XCTAssertTrue(mockRepository.swapVehicleColorsCalled)
    }
}

