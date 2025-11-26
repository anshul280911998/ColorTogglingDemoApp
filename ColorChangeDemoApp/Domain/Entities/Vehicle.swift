//
//  Vehicle.swift
//  ColorChangeDemoApp
//
//  Created by luminous on 26/11/25.
//

import Foundation
import SwiftUI

struct Vehicle: Identifiable, Codable, Equatable {
    let id: UUID
    let name: String
    var color: String // Stored as color name string (e.g., "red", "blue")
    
    init(id: UUID = UUID(), name: String, color: String) {
        self.id = id
        self.name = name
        self.color = color
    }
    
    var swiftUIColor: Color {
        Color(colorName: color) ?? .blue
    }
    
    mutating func updateColor(_ newColor: Color) {
        self.color = newColor.toColorName() ?? "blue"
    }
}

// MARK: - Color Extensions
extension Color {
    init?(colorName: String) {
        let lowercased = colorName.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        switch lowercased {
        case "red":
            self = .red
        case "blue":
            self = .blue
        case "green":
            self = .green
        case "yellow":
            self = .yellow
        case "orange":
            self = .orange
        case "purple":
            self = .purple
        case "pink":
            self = .pink
        case "black":
            self = .black
        case "white":
            self = .white
        case "gray", "grey":
            self = .gray
        case "brown":
            self = .brown
        case "cyan":
            self = .cyan
        case "magenta":
            // Magenta is not a standard SwiftUI color, so we create it using RGB
            self = Color(red: 1.0, green: 0.0, blue: 1.0)
        default:
            return nil
        }
    }
    
    func toColorName() -> String? {
        // Compare with standard SwiftUI colors
        if self == .red {
            return "red"
        } else if self == .blue {
            return "blue"
        } else if self == .green {
            return "green"
        } else if self == .yellow {
            return "yellow"
        } else if self == .orange {
            return "orange"
        } else if self == .purple {
            return "purple"
        } else if self == .pink {
            return "pink"
        } else if self == .black {
            return "black"
        } else if self == .white {
            return "white"
        } else if self == .gray {
            return "gray"
        } else if self == .brown {
            return "brown"
        } else if self == .cyan {
            return "cyan"
        }
        
        // Fallback: try to match by RGB values for common colors
        #if canImport(UIKit)
        let uiColor = UIColor(self)
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        guard uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha) else {
            return nil
        }
        
        let r = Int(red * 255)
        let g = Int(green * 255)
        let b = Int(blue * 255)
        
        // Match common color values
        if r > 200 && g < 50 && b < 50 {
            return "red"
        } else if r < 50 && g < 50 && b > 200 {
            return "blue"
        } else if r < 50 && g > 200 && b < 50 {
            return "green"
        } else if r > 200 && g > 200 && b < 50 {
            return "yellow"
        } else if r > 200 && g < 50 && b > 200 {
            return "magenta"
        }
        #endif
        
        return nil
    }
}

