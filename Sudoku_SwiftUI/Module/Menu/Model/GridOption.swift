//
//  GridOption.swift
//  Sudoku_SwiftUI
//
//  Created by Dileep Kumar on 13/10/25.
//

import SwiftUI

struct GridOption: Identifiable, Equatable {
    let id = UUID()
    let image: Image?
    let color: Color
}

struct GridAPI: Identifiable, Decodable {
    let grid_id: Int
    let grid_image: String
    let status: Bool
    let grid_color: String
    let created_at: String
    let updated_at: String

    var id: Int { grid_id }

    enum CodingKeys: String, CodingKey {
        case grid_id
        case grid_image
        case status
        case grid_color
        case created_at
        case updated_at
    }
}

extension Color {
    init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if hexSanitized.hasPrefix("#") {
            hexSanitized.removeFirst()
        } else if hexSanitized.hasPrefix("0X") {
            hexSanitized.removeFirst(2)
        }

        guard hexSanitized.count == 6 else {
            print("❌ Invalid hex color:", hex)
            return nil
        }

        var rgbValue: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgbValue)

        let red = Double((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = Double((rgbValue & 0x00FF00) >> 8) / 255.0
        let blue = Double(rgbValue & 0x0000FF) / 255.0

        self.init(red: red, green: green, blue: blue)
    }
}
