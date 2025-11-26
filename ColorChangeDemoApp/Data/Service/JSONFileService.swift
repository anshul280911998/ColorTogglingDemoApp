//
//  JSONFileResponse.swift
//  ColorChangeDemoApp
//
//  Created by luminous on 26/11/25.
//

import Foundation

final class JSONFileService {
    static let shared = JSONFileService()
    
    private let fileName = "vehicles.json"
    
    private var documentsDirectory: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    private var fileURL: URL {
        documentsDirectory.appendingPathComponent(fileName)
    }
    
    private init() {
        // Create initial JSON file if it doesn't exist
        createInitialJSONIfNeeded()
    }
    
    private func createInitialJSONIfNeeded() {
        guard !FileManager.default.fileExists(atPath: fileURL.path) else {
            return
        }
        
        let initialVehicles = [
            Vehicle(name: "car", color: "blue"),
            Vehicle(name: "truck", color: "yellow")
        ]
        
        let response = VehiclesResponse(vehicles: initialVehicles)
        saveToFile(response)
    }
    
    func loadVehicles() throws -> [Vehicle] {
        guard FileManager.default.fileExists(atPath: fileURL.path) else {
            createInitialJSONIfNeeded()
            return try loadVehicles()
        }
        
        let data = try Data(contentsOf: fileURL)
        let decoder = JSONDecoder()
        var response = try decoder.decode(VehiclesResponse.self, from: data)
        
        // Fix: If both vehicles have the same color, update truck to yellow
        if response.vehicles.count >= 2 {
            let car = response.vehicles.first(where: { $0.name == "car" })
            let truck = response.vehicles.first(where: { $0.name == "truck" })
            
            if let car = car, let truck = truck {
                // Log both vehicles from response
                print("📥 Loaded from JSON response:")
                print("   - Vehicle '\(car.name)' color: '\(car.color)'")
                print("   - Vehicle '\(truck.name)' color: '\(truck.color)'")
                
                if car.color == truck.color {
                    // Both have same color, update truck to yellow
                    var updatedVehicles = response.vehicles
                    if let truckIndex = updatedVehicles.firstIndex(where: { $0.name == "truck" }) {
                        updatedVehicles[truckIndex].color = "yellow"
                        response = VehiclesResponse(vehicles: updatedVehicles)
                        try saveVehicles(updatedVehicles)
                        print("✅ Updated vehicle 'truck' color to 'yellow' in JSON file (was same as car)")
                    }
                }
            }
        }
        
        return response.vehicles
    }
    
    func saveVehicles(_ vehicles: [Vehicle]) throws {
        let response = VehiclesResponse(vehicles: vehicles)
        saveToFile(response)
    }
    
    private func saveToFile(_ response: VehiclesResponse) {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        
        do {
            let data = try encoder.encode(response)
            try data.write(to: fileURL, options: [.atomic])
            print("✅ JSON file saved to: \(fileURL.path)")
        } catch {
            print("❌ Error saving JSON file: \(error)")
        }
    }
    
    func getFileURL() -> URL {
        return fileURL
    }
}

