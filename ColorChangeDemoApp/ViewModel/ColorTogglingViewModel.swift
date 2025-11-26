//
//  ColorTogglingViewModel.swift
//  ColorChangeDemoApp
//
//  Created by luminous on 26/11/25.
//

import Foundation
import SwiftUI

@MainActor
final class ColorTogglingViewModel: ObservableObject {
    @Published var vehicle1: Vehicle?
    @Published var vehicle2: Vehicle?
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var jsonContent: String = ""
    @Published var apiStatus: String = "Ready"
    @Published var lastStatusCode: Int = 0
    @Published var showErrorAlert: Bool = false
    @Published var alertMessage: String = ""
    
    private let getVehiclesUseCase: GetVehiclesUseCaseProtocol
    private let swapVehicleColorsUseCase: SwapVehicleColorsUseCaseProtocol
    
    init(
        getVehiclesUseCase: GetVehiclesUseCaseProtocol,
        swapVehicleColorsUseCase: SwapVehicleColorsUseCaseProtocol
    ) {
        self.getVehiclesUseCase = getVehiclesUseCase
        self.swapVehicleColorsUseCase = swapVehicleColorsUseCase
    }
    
    func loadVehicles() async {
        isLoading = true
        errorMessage = nil
        apiStatus = "Loading vehicles..."
        
        let response = await getVehiclesUseCase.execute()
        lastStatusCode = response.statusCode
        apiStatus = "GET /vehicles - \(response.statusCode) - \(response.message)"
        
        if response.isSuccess, let vehicles = response.data {
            guard vehicles.count >= 2 else {
                errorMessage = "Expected at least 2 vehicles"
                apiStatus = "GET /vehicles - Error: Expected at least 2 vehicles"
                isLoading = false
                return
            }
            vehicle1 = vehicles[0]
            vehicle2 = vehicles[1]
            updateJSONContent()
        } else {
            errorMessage = response.message
            apiStatus = "GET /vehicles - \(response.statusCode) - Error: \(response.message)"
        }
        
        isLoading = false
    }
    
    func swapColors() async {
        guard let vehicle1 = vehicle1, let vehicle2 = vehicle2 else {
            errorMessage = "Vehicles not loaded"
            apiStatus = "Error: Vehicles not loaded"
            return
        }
        
        isLoading = true
        errorMessage = nil
        apiStatus = "Swapping colors..."
        
        // Add 2 second delay
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        
        let response = await swapVehicleColorsUseCase.execute(
            vehicle1: vehicle1,
            vehicle2: vehicle2
        )
        
        lastStatusCode = response.statusCode
        apiStatus = "Status code - \(response.statusCode)"
        
        if response.isSuccess, let swapResponse = response.data {
            self.vehicle1 = swapResponse.vehicle1
            self.vehicle2 = swapResponse.vehicle2
            updateJSONContent()
        } else {
            errorMessage = response.message
            apiStatus = "Status code - \(response.statusCode)"
            // Show alert for failed API call (status code not in 2xx range)
            if response.statusCode < 200 || response.statusCode >= 300 {
                alertMessage = "API call failed with status code \(response.statusCode): \(response.message)"
                showErrorAlert = true
            }
        }
        
        isLoading = false
    }
    
    var vehicle1Color: Color {
        vehicle1?.swiftUIColor ?? .yellow
    }
    
    var vehicle2Color: Color {
        vehicle2?.swiftUIColor ?? .red
    }
    
    var vehicle1Name: String {
        vehicle1?.name.capitalized ?? "Car"
    }
    
    var vehicle2Name: String {
        vehicle2?.name.capitalized ?? "Truck"
    }
    
    var jsonFilePath: String {
        JSONFileService.shared.getFileURL().path
    }
    
    private func updateJSONContent() {
        guard let data = try? Data(contentsOf: JSONFileService.shared.getFileURL()),
              let jsonString = String(data: data, encoding: .utf8) else {
            jsonContent = "Unable to load JSON"
            return
        }
        jsonContent = jsonString
    }
}

