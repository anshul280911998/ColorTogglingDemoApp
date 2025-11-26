//
//  APIResponse.swift
//  ColorChangeDemoApp
//
//  Created by luminous on 26/11/25.
//

import Foundation

struct APIResponse<T: Codable> {
    let statusCode: Int
    let data: T?
    let error: APIError?
    let message: String
    
    var isSuccess: Bool {
        statusCode >= 200 && statusCode < 300
    }
    
    init(statusCode: Int, data: T? = nil, error: APIError? = nil, message: String = "") {
        self.statusCode = statusCode
        self.data = data
        self.error = error
        self.message = message
    }
}

enum HTTPStatusCode: Int {
    // 2xx Success
    case ok = 200
    case created = 201
    case accepted = 202
    case noContent = 204
    
    // 4xx Client Error
    case badRequest = 400
    case unauthorized = 401
    case forbidden = 403
    case notFound = 404
    case methodNotAllowed = 405
    case conflict = 409
    case unprocessableEntity = 422
    
    // 5xx Server Error
    case internalServerError = 500
    case badGateway = 502
    case serviceUnavailable = 503
    case gatewayTimeout = 504
    
    var description: String {
        switch self {
        case .ok:
            return "OK - Request succeeded"
        case .created:
            return "Created - Resource created successfully"
        case .accepted:
            return "Accepted - Request accepted for processing"
        case .noContent:
            return "No Content - Request succeeded but no content to return"
        case .badRequest:
            return "Bad Request - Invalid request parameters"
        case .unauthorized:
            return "Unauthorized - Authentication required"
        case .forbidden:
            return "Forbidden - Access denied"
        case .notFound:
            return "Not Found - Resource not found"
        case .methodNotAllowed:
            return "Method Not Allowed - HTTP method not supported"
        case .conflict:
            return "Conflict - Resource conflict"
        case .unprocessableEntity:
            return "Unprocessable Entity - Validation failed"
        case .internalServerError:
            return "Internal Server Error - Server error"
        case .badGateway:
            return "Bad Gateway - Gateway error"
        case .serviceUnavailable:
            return "Service Unavailable - Service temporarily unavailable"
        case .gatewayTimeout:
            return "Gateway Timeout - Request timeout"
        }
    }
    
    var statusMessage: String {
        return "\(rawValue) - \(description)"
    }
}


