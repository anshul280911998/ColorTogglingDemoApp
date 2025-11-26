//
//  VehicleTests.swift
//  ColorChangeDemoAppTests
//
//  Created by luminous on 26/11/25.
//

import XCTest
import SwiftUI
@testable import ColorChangeDemoApp

final class VehicleTests: XCTestCase {
    
    // MARK: - Initialization Tests
    
    func testVehicle_Initialization() {
        // Given
        let id = UUID()
        let name = "car"
        let color = "red"
        
        // When
        let vehicle = Vehicle(id: id, name: name, color: color)
        
        // Then
        XCTAssertEqual(vehicle.id, id)
        XCTAssertEqual(vehicle.name, name)
        XCTAssertEqual(vehicle.color, color)
    }
    
    func testVehicle_DefaultInitialization() {
        // When
        let vehicle = Vehicle(name: "truck", color: "blue")
        
        // Then
        XCTAssertNotNil(vehicle.id)
        XCTAssertEqual(vehicle.name, "truck")
        XCTAssertEqual(vehicle.color, "blue")
    }
    
    // MARK: - Color Conversion Tests
    
    func testSwiftUIColor_Red() {
        // Given
        let vehicle = Vehicle(name: "car", color: "red")
        
        // Then
        XCTAssertEqual(vehicle.swiftUIColor, .red)
    }
    
    func testSwiftUIColor_Blue() {
        // Given
        let vehicle = Vehicle(name: "car", color: "blue")
        
        // Then
        XCTAssertEqual(vehicle.swiftUIColor, .blue)
    }
    
    func testSwiftUIColor_Green() {
        // Given
        let vehicle = Vehicle(name: "car", color: "green")
        
        // Then
        XCTAssertEqual(vehicle.swiftUIColor, .green)
    }
    
    func testSwiftUIColor_Yellow() {
        // Given
        let vehicle = Vehicle(name: "car", color: "yellow")
        
        // Then
        XCTAssertEqual(vehicle.swiftUIColor, .yellow)
    }
    
    func testSwiftUIColor_InvalidColor() {
        // Given
        let vehicle = Vehicle(name: "car", color: "invalidcolor")
        
        // Then - should default to blue
        XCTAssertEqual(vehicle.swiftUIColor, .blue)
    }
    
    func testSwiftUIColor_CaseInsensitive() {
        // Given
        let vehicle1 = Vehicle(name: "car", color: "RED")
        let vehicle2 = Vehicle(name: "car", color: "Red")
        let vehicle3 = Vehicle(name: "car", color: "red")
        
        // Then
        XCTAssertEqual(vehicle1.swiftUIColor, .red)
        XCTAssertEqual(vehicle2.swiftUIColor, .red)
        XCTAssertEqual(vehicle3.swiftUIColor, .red)
    }
    
    func testSwiftUIColor_WithWhitespace() {
        // Given
        let vehicle = Vehicle(name: "car", color: "  red  ")
        
        // Then
        XCTAssertEqual(vehicle.swiftUIColor, .red)
    }
    
    func testUpdateColor_Red() {
        // Given
        var vehicle = Vehicle(name: "car", color: "blue")
        
        // When
        vehicle.updateColor(.red)
        
        // Then
        XCTAssertEqual(vehicle.color, "red")
    }
    
    func testUpdateColor_Blue() {
        // Given
        var vehicle = Vehicle(name: "car", color: "red")
        
        // When
        vehicle.updateColor(.blue)
        
        // Then
        XCTAssertEqual(vehicle.color, "blue")
    }
    
    // MARK: - Equatable Tests
    
    func testVehicle_Equality() {
        // Given
        let id = UUID()
        let vehicle1 = Vehicle(id: id, name: "car", color: "red")
        let vehicle2 = Vehicle(id: id, name: "car", color: "red")
        
        // Then
        XCTAssertEqual(vehicle1, vehicle2)
    }
    
    func testVehicle_Inequality_DifferentID() {
        // Given
        let vehicle1 = Vehicle(name: "car", color: "red")
        let vehicle2 = Vehicle(name: "car", color: "red")
        
        // Then - different IDs
        XCTAssertNotEqual(vehicle1, vehicle2)
    }
    
    func testVehicle_Inequality_DifferentName() {
        // Given
        let id = UUID()
        let vehicle1 = Vehicle(id: id, name: "car", color: "red")
        let vehicle2 = Vehicle(id: id, name: "truck", color: "red")
        
        // Then
        XCTAssertNotEqual(vehicle1, vehicle2)
    }
    
    func testVehicle_Inequality_DifferentColor() {
        // Given
        let id = UUID()
        let vehicle1 = Vehicle(id: id, name: "car", color: "red")
        let vehicle2 = Vehicle(id: id, name: "car", color: "blue")
        
        // Then
        XCTAssertNotEqual(vehicle1, vehicle2)
    }
    
    // MARK: - Color Extension Tests
    
    func testColor_InitFromColorName_ValidColors() {
        // Test various valid color names
        XCTAssertEqual(Color(colorName: "red"), .red)
        XCTAssertEqual(Color(colorName: "blue"), .blue)
        XCTAssertEqual(Color(colorName: "green"), .green)
        XCTAssertEqual(Color(colorName: "yellow"), .yellow)
        XCTAssertEqual(Color(colorName: "orange"), .orange)
        XCTAssertEqual(Color(colorName: "purple"), .purple)
        XCTAssertEqual(Color(colorName: "pink"), .pink)
        XCTAssertEqual(Color(colorName: "black"), .black)
        XCTAssertEqual(Color(colorName: "white"), .white)
        XCTAssertEqual(Color(colorName: "gray"), .gray)
        XCTAssertEqual(Color(colorName: "grey"), .gray)
        XCTAssertEqual(Color(colorName: "brown"), .brown)
        XCTAssertEqual(Color(colorName: "cyan"), .cyan)
    }
    
    func testColor_InitFromColorName_InvalidColor() {
        // Given
        let color = Color(colorName: "invalidcolor")
        
        // Then
        XCTAssertNil(color)
    }
    
    func testColor_ToColorName_ValidColors() {
        // Test conversion back to color name
        XCTAssertEqual(Color.red.toColorName(), "red")
        XCTAssertEqual(Color.blue.toColorName(), "blue")
        XCTAssertEqual(Color.green.toColorName(), "green")
        XCTAssertEqual(Color.yellow.toColorName(), "yellow")
        XCTAssertEqual(Color.orange.toColorName(), "orange")
        XCTAssertEqual(Color.purple.toColorName(), "purple")
        XCTAssertEqual(Color.pink.toColorName(), "pink")
        XCTAssertEqual(Color.black.toColorName(), "black")
        XCTAssertEqual(Color.white.toColorName(), "white")
        XCTAssertEqual(Color.gray.toColorName(), "gray")
        XCTAssertEqual(Color.brown.toColorName(), "brown")
        XCTAssertEqual(Color.cyan.toColorName(), "cyan")
    }
}

