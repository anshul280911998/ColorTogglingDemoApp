//
//  APIResponseTests.swift
//  ColorChangeDemoAppTests
//
//  Created by luminous on 26/11/25.
//

import XCTest
@testable import ColorChangeDemoApp

final class APIResponseTests: XCTestCase {
    
    
    func testIsSuccess_200() {
        // Given
        let response = APIResponse<String>(
            statusCode: 200,
            data: "test",
            message: "OK"
        )
        
        // Then
        XCTAssertTrue(response.isSuccess)
    }
    
    func testIsSuccess_201() {
        // Given
        let response = APIResponse<String>(
            statusCode: 201,
            data: "test",
            message: "Created"
        )
        
        // Then
        XCTAssertTrue(response.isSuccess)
    }
    
    func testIsSuccess_299() {
        // Given
        let response = APIResponse<String>(
            statusCode: 299,
            data: "test",
            message: "OK"
        )
        
        // Then
        XCTAssertTrue(response.isSuccess)
    }
    
    // MARK: - Failure Status Tests
    
    func testIsSuccess_400() {
        // Given
        let response = APIResponse<String>(
            statusCode: 400,
            error: APIError.invalidResponse,
            message: "Bad Request"
        )
        
        // Then
        XCTAssertFalse(response.isSuccess)
    }
    
    func testIsSuccess_404() {
        // Given
        let response = APIResponse<String>(
            statusCode: 404,
            error: APIError.vehicleNotFound,
            message: "Not Found"
        )
        
        // Then
        XCTAssertFalse(response.isSuccess)
    }
    
    func testIsSuccess_500() {
        // Given
        let response = APIResponse<String>(
            statusCode: 500,
            error: APIError.networkError,
            message: "Internal Server Error"
        )
        
        // Then
        XCTAssertFalse(response.isSuccess)
    }
    
    func testIsSuccess_199() {
        // Given
        let response = APIResponse<String>(
            statusCode: 199,
            message: "Informational"
        )
        
        // Then
        XCTAssertFalse(response.isSuccess)
    }
    
    func testIsSuccess_300() {
        // Given
        let response = APIResponse<String>(
            statusCode: 300,
            message: "Multiple Choices"
        )
        
        // Then
        XCTAssertFalse(response.isSuccess)
    }
    
    // MARK: - Initialization Tests
    
    func testInitialization_WithData() {
        // Given
        let data = "test data"
        
        // When
        let response = APIResponse(
            statusCode: 200,
            data: data,
            message: "Success"
        )
        
        // Then
        XCTAssertEqual(response.statusCode, 200)
        XCTAssertEqual(response.data, data)
        XCTAssertNil(response.error)
        XCTAssertEqual(response.message, "Success")
    }
    
    func testInitialization_WithError() {
        // Given
        let error = APIError.networkError
        
        // When
        let response = APIResponse<String>(
            statusCode: 500,
            error: error,
            message: "Error"
        )
        
        // Then
        XCTAssertEqual(response.statusCode, 500)
        XCTAssertNil(response.data)
        XCTAssertEqual(response.error, error)
        XCTAssertEqual(response.message, "Error")
    }
    
    func testInitialization_DefaultMessage() {
        // Given
        let response = APIResponse<String>(
            statusCode: 200,
            data: "test"
        )
        
        // Then
        XCTAssertEqual(response.message, "")
    }
}

