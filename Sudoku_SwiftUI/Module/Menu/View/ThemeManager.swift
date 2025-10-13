//
//  ThemeManager.swift
//  Sudoku_SwiftUI
//
//  Created by Dileep Kumar on 13/10/25.
//

import SwiftUI
import Combine

// MARK: - Theme Manager

class ThemeManager: ObservableObject {
    static let shared = ThemeManager()
    @Published var selectedTheme: Theme = Theme(name: "Bamboo Zen", imageName: "Bamboo Zen")
    @Published var selectedGridColor: Color = .white
    private init() {}
}
