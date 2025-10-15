//
//  MenuModel.swift
//  Sudoku_SwiftUI
//
//  Created by Dileep Kumar on 10/10/25.
//

import Combine

// MARK: - Menu Model

class MenuModel: ObservableObject {
    
    // MARK: - Properties
    @Published var showDifficultyPopup = false
    @Published var goToStartGame = false
    @Published var goToTips = false
    @Published var goToThemes = false
    @Published var goToScoreBoard = false
    @Published var selectedLevel: String = "Easy"
    
    func moveToStartGame() {
        showDifficultyPopup = true
    }
    
    func moveToTips() {
        
    }
    
    func moveToThemes() {
        goToThemes = true
    }
    
    func moveToMyScoreBoard() {
        goToScoreBoard = true
    }
}
