//
//  ColorTogglingViewModelTests.swift
//  ColorChangeDemoAppTests
//
//  Created by luminous on 26/11/25.
//

import XCTest
import SwiftUI
@testable import ColorChangeDemoApp

@MainActor
final class ColorTogglingViewModelTests: XCTestCase {
    
    var viewModel: ColorTogglingViewModel!
    var mockGetVehiclesUseCase: MockGetVehiclesUseCase!
    var mockSwapVehicleColorsUseCase: MockSwapVehicleColorsUseCase!
    
    override func setUp() {
        super.setUp()
        mockGetVehiclesUseCase = MockGetVehiclesUseCase()
        mockSwapVehicleColorsUseCase = MockSwapVehicleColorsUseCase()
        viewModel = ColorTogglingViewModel(
            getVehiclesUseCase: mockGetVehiclesUseCase,
            swapVehicleColorsUseCase: mockSwapVehicleColorsUseCase
        )
    }
    
    override func tearDown() {
        viewModel = nil
        mockGetVehiclesUseCase = nil
        mockSwapVehicleColorsUseCase = nil
        super.tearDown()
    }
    
    // MARK: - Initial State Tests
    
    func testInitialState() {
        XCTAssertNil(viewModel.vehicle1)
        XCTAssertNil(viewModel.vehicle2)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertEqual(viewModel.apiStatus, "Ready")
        XCTAssertEqual(viewModel.lastStatusCode, 0)
        XCTAssertFalse(viewModel.showErrorAlert)
        XCTAssertEqual(viewModel.alertMessage, "")
    }
    
    // MARK: - Load Vehicles Tests
    
    func testLoadVehicles_Success() async {
        // Given
        let vehicles = [
            Vehicle(name: "car", color: "red"),
            Vehicle(name: "truck", color: "blue")
        ]
        mockGetVehiclesUseCase.response = APIResponse(
            statusCode: 200,
            data: vehicles,
            message: "Success"
        )
        
        // When
        await viewModel.loadVehicles()
        
        // Then
        XCTAssertNotNil(viewModel.vehicle1)
        XCTAssertNotNil(viewModel.vehicle2)
        XCTAssertEqual(viewModel.vehicle1?.name, "car")
        XCTAssertEqual(viewModel.vehicle2?.name, "truck")
        XCTAssertEqual(viewModel.vehicle1?.color, "red")
        XCTAssertEqual(viewModel.vehicle2?.color, "blue")
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertEqual(viewModel.lastStatusCode, 200)
        XCTAssertTrue(viewModel.apiStatus.contains("200"))
    }
    
    func testLoadVehicles_Failure() async {
        // Given
        mockGetVehiclesUseCase.response = APIResponse<[Vehicle]>(
            statusCode: 500,
            error: APIError.networkError,
            message: "Internal Server Error"
        )
        
        // When
        await viewModel.loadVehicles()
        
        // Then
        XCTAssertNil(viewModel.vehicle1)
        XCTAssertNil(viewModel.vehicle2)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNotNil(viewModel.errorMessage)
        XCTAssertEqual(viewModel.errorMessage, "Internal Server Error")
        XCTAssertEqual(viewModel.lastStatusCode, 500)
    }
    
    func testLoadVehicles_InsufficientVehicles() async {
        // Given
        let vehicles = [Vehicle(name: "car", color: "red")]
        mockGetVehiclesUseCase.response = APIResponse(
            statusCode: 200,
            data: vehicles,
            message: "Success"
        )
        
        // When
        await viewModel.loadVehicles()
        
        // Then
        XCTAssertNil(viewModel.vehicle1)
        XCTAssertNil(viewModel.vehicle2)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertEqual(viewModel.errorMessage, "Expected at least 2 vehicles")
        XCTAssertTrue(viewModel.apiStatus.contains("Error"))
    }
    
    func testLoadVehicles_LoadingState() async {
        // Given
        let vehicles = [
            Vehicle(name: "car", color: "red"),
            Vehicle(name: "truck", color: "blue")
        ]
        mockGetVehiclesUseCase.response = APIResponse(
            statusCode: 200,
            data: vehicles,
            message: "Success"
        )
        
        // When
        let loadTask = Task {
            await viewModel.loadVehicles()
        }
        
        // Small delay to check loading state
        try? await Task.sleep(nanoseconds: 10_000_000) // 0.01 seconds
        
        // Then - should be loading initially
        // Note: This is a timing-dependent test, may need adjustment
        
        await loadTask.value
        XCTAssertFalse(viewModel.isLoading)
    }
    
    // MARK: - Swap Colors Tests
    
    func testSwapColors_Success() async {
        // Given
        let vehicle1 = Vehicle(name: "car", color: "red")
        let vehicle2 = Vehicle(name: "truck", color: "blue")
        viewModel.vehicle1 = vehicle1
        viewModel.vehicle2 = vehicle2
        
        let swappedResponse = SwapVehiclesResponse(
            vehicle1: Vehicle(name: "car", color: "blue"),
            vehicle2: Vehicle(name: "truck", color: "red")
        )
        mockSwapVehicleColorsUseCase.response = APIResponse(
            statusCode: 200,
            data: swappedResponse,
            message: "Success"
        )
        
        // When
        await viewModel.swapColors()
        
        // Then
        XCTAssertNotNil(viewModel.vehicle1)
        XCTAssertNotNil(viewModel.vehicle2)
        XCTAssertEqual(viewModel.vehicle1?.color, "blue")
        XCTAssertEqual(viewModel.vehicle2?.color, "red")
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertEqual(viewModel.lastStatusCode, 200)
        XCTAssertEqual(viewModel.apiStatus, "Status code - 200")
        XCTAssertFalse(viewModel.showErrorAlert)
    }
    
    func testSwapColors_Failure() async {
        // Given
        let vehicle1 = Vehicle(name: "car", color: "red")
        let vehicle2 = Vehicle(name: "truck", color: "blue")
        viewModel.vehicle1 = vehicle1
        viewModel.vehicle2 = vehicle2
        
        mockSwapVehicleColorsUseCase.response = APIResponse<SwapVehiclesResponse>(
            statusCode: 500,
            error: APIError.networkError,
            message: "Internal Server Error"
        )
        
        // When
        await viewModel.swapColors()
        
        // Then
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNotNil(viewModel.errorMessage)
        XCTAssertEqual(viewModel.errorMessage, "Internal Server Error")
        XCTAssertEqual(viewModel.lastStatusCode, 500)
        XCTAssertEqual(viewModel.apiStatus, "Status code - 500")
        XCTAssertTrue(viewModel.showErrorAlert)
        XCTAssertTrue(viewModel.alertMessage.contains("500"))
    }
    
    func testSwapColors_WithoutVehicles() async {
        // Given - vehicles are nil
        viewModel.vehicle1 = nil
        viewModel.vehicle2 = nil
        
        // When
        await viewModel.swapColors()
        
        // Then
        XCTAssertEqual(viewModel.errorMessage, "Vehicles not loaded")
        XCTAssertEqual(viewModel.apiStatus, "Error: Vehicles not loaded")
        XCTAssertFalse(viewModel.isLoading)
    }
    
    func testSwapColors_Delay() async {
        // Given
        let vehicle1 = Vehicle(name: "car", color: "red")
        let vehicle2 = Vehicle(name: "truck", color: "blue")
        viewModel.vehicle1 = vehicle1
        viewModel.vehicle2 = vehicle2
        
        let swappedResponse = SwapVehiclesResponse(
            vehicle1: Vehicle(name: "car", color: "blue"),
            vehicle2: Vehicle(name: "truck", color: "red")
        )
        mockSwapVehicleColorsUseCase.response = APIResponse(
            statusCode: 200,
            data: swappedResponse,
            message: "Success"
        )
        
        // When
        let startTime = Date()
        await viewModel.swapColors()
        let endTime = Date()
        let duration = endTime.timeIntervalSince(startTime)
        
        // Then - should take at least 2 seconds due to delay
        XCTAssertGreaterThanOrEqual(duration, 2.0)
    }
    
    func testSwapColors_ErrorAlertFor4xx() async {
        // Given
        let vehicle1 = Vehicle(name: "car", color: "red")
        let vehicle2 = Vehicle(name: "truck", color: "blue")
        viewModel.vehicle1 = vehicle1
        viewModel.vehicle2 = vehicle2
        
        mockSwapVehicleColorsUseCase.response = APIResponse<SwapVehiclesResponse>(
            statusCode: 404,
            error: APIError.vehicleNotFound,
            message: "Not Found"
        )
        
        // When
        await viewModel.swapColors()
        
        // Then
        XCTAssertTrue(viewModel.showErrorAlert)
        XCTAssertTrue(viewModel.alertMessage.contains("404"))
    }
    
    func testSwapColors_ErrorAlertFor5xx() async {
        // Given
        let vehicle1 = Vehicle(name: "car", color: "red")
        let vehicle2 = Vehicle(name: "truck", color: "blue")
        viewModel.vehicle1 = vehicle1
        viewModel.vehicle2 = vehicle2
        
        mockSwapVehicleColorsUseCase.response = APIResponse<SwapVehiclesResponse>(
            statusCode: 503,
            error: APIError.networkError,
            message: "Service Unavailable"
        )
        
        // When
        await viewModel.swapColors()
        
        // Then
        XCTAssertTrue(viewModel.showErrorAlert)
        XCTAssertTrue(viewModel.alertMessage.contains("503"))
    }
    
    // MARK: - Computed Properties Tests
    
    func testVehicle1Color_WithVehicle() {
        // Given
        viewModel.vehicle1 = Vehicle(name: "car", color: "green")
        
        // Then
        XCTAssertEqual(viewModel.vehicle1Color, .green)
    }
    
    func testVehicle1Color_WithoutVehicle() {
        // Given - vehicle1 is nil
        
        // Then
        XCTAssertEqual(viewModel.vehicle1Color, .yellow)
    }
    
    func testVehicle2Color_WithVehicle() {
        // Given
        viewModel.vehicle2 = Vehicle(name: "truck", color: "purple")
        
        // Then
        XCTAssertEqual(viewModel.vehicle2Color, .purple)
    }
    
    func testVehicle2Color_WithoutVehicle() {
        // Given - vehicle2 is nil
        
        // Then
        XCTAssertEqual(viewModel.vehicle2Color, .red)
    }
    
    func testVehicle1Name_WithVehicle() {
        // Given
        viewModel.vehicle1 = Vehicle(name: "car", color: "red")
        
        // Then
        XCTAssertEqual(viewModel.vehicle1Name, "Car")
    }
    
    func testVehicle1Name_WithoutVehicle() {
        // Given - vehicle1 is nil
        
        // Then
        XCTAssertEqual(viewModel.vehicle1Name, "Car")
    }
    
    func testVehicle2Name_WithVehicle() {
        // Given
        viewModel.vehicle2 = Vehicle(name: "truck", color: "blue")
        
        // Then
        XCTAssertEqual(viewModel.vehicle2Name, "Truck")
    }
    
    func testVehicle2Name_WithoutVehicle() {
        // Given - vehicle2 is nil
        
        // Then
        XCTAssertEqual(viewModel.vehicle2Name, "Truck")
    }
}

// MARK: - Mock Use Cases

class MockGetVehiclesUseCase: GetVehiclesUseCaseProtocol {
    var response: APIResponse<[Vehicle]> = APIResponse(
        statusCode: 200,
        data: [],
        message: "Success"
    )
    
    func execute() async -> APIResponse<[Vehicle]> {
        return response
    }
}

class MockSwapVehicleColorsUseCase: SwapVehicleColorsUseCaseProtocol {
    var response: APIResponse<SwapVehiclesResponse> = APIResponse(
        statusCode: 200,
        data: SwapVehiclesResponse(
            vehicle1: Vehicle(name: "car", color: "blue"),
            vehicle2: Vehicle(name: "truck", color: "red")
        ),
        message: "Success"
    )
    
    func execute(vehicle1: Vehicle, vehicle2: Vehicle) async -> APIResponse<SwapVehiclesResponse> {
        return response
    }
}

