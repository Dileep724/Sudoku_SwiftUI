//
//  ThemesViewModel.swift
//  Sudoku_SwiftUI
//
//  Created by Dileep Kumar on 11/10/25.
//

import SwiftUI
import Combine

class ThemesViewModel: ObservableObject {
    
    // MARK: - Properties
    
    @Published var isThemesViewVisible = true
    
    let themes: [Theme] = [
        Theme(name: "Bamboo Zen", imageName: "Bamboo Zen"),
        Theme(name: "Mountain View", imageName: "bg1"),
        Theme(name: "Ocean Blue", imageName: "bg2"),
        Theme(name: "Sunset Glow", imageName: "bg4"),
        Theme(name: "Forest Mist", imageName: "bg5"),
        Theme(name: "Night Sky", imageName: "bg6")
    ]
    
    let gridOptions: [GridOption] = [
         GridOption(imageName: "grid1", color: Color(.systemGray5)),
         GridOption(imageName: "grid2", color: Color(red: 200/255, green: 230/255, blue: 255/255)),
         GridOption(imageName: "grid3", color: Color(red: 245/255, green: 245/255, blue: 220/255)),
         GridOption(imageName: "grid4", color: Color(red: 200/255, green: 255/255, blue: 200/255))
     ]
    
    func selectTheme(_ theme: Theme) {
        ThemeManager.shared.selectedTheme = theme
    }
    
    func selectGridOption(_ option: GridOption) {
        ThemeManager.shared.selectedGridColor = option.color
    }
    
    func closeThemesView() {
        isThemesViewVisible = false
    }
}
