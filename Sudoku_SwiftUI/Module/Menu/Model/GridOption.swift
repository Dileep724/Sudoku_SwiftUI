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
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0

        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        let red = Double((rgb & 0xFF0000) >> 16) / 255.0
        let green = Double((rgb & 0x00FF00) >> 8) / 255.0
        let blue = Double(rgb & 0x0000FF) / 255.0

        self.init(red: red, green: green, blue: blue)
    }
}
