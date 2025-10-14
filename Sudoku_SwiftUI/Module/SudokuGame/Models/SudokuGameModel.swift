//
//  SudokuGameModel.swift
//  Sudoku_SwiftUI
//
//  Created by Sai Babu on 14/10/25.
//
import Foundation

struct SudokuPuzzle: Codable {
    let sudokuID: Int
    let category, eventID: String
    let puzzleDate: String
    let status: Bool
    let undoLimit, redoLimit, hintLimit: Int
    let puzzleString: String
    let solutionString: String
    
    var puzzle: [[Int]] { decodeArray(from: puzzleString) }
    var solution: [[Int]] { decodeArray(from: solutionString) }
    
    enum CodingKeys: String, CodingKey {
        case sudokuID = "sudoku_id"
        case category
        case eventID = "event_id"
        case puzzleString = "puzzle"
        case solutionString = "solution"
        case puzzleDate = "puzzle_date"
        case status
        case undoLimit = "undo_limit"
        case redoLimit = "redo_limit"
        case hintLimit = "hint_limit"
    }
    
    private func decodeArray(from string: String) -> [[Int]] {
        guard let data = string.data(using: .utf8) else { return [] }
        return (try? JSONDecoder().decode([[Int]].self, from: data)) ?? []
    }
}


