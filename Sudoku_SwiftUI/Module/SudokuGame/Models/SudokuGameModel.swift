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
struct TournamentPuzzleResponse: Decodable {
    let tournament_id: Int?
    let tournament_name: String?
    let round_name: String?
    let round_id: Int?
    let round_number: Int?
    let end_datetime: String?
    let sudoku: TournamentSudokuPuzzle

    struct TournamentSudokuPuzzle: Decodable {
        let sudoku_id: Int
        let puzzle: [[Int]]
        let solution: [[Int]]
        let category: String
        let hint_limit: Int?
        let undo_limit: Int
        let redo_limit: Int
    }
}
struct BasicResponse: Codable {
    let status: String
    let message: String
}

struct SudokuResultResponse: Codable {
    let rider_id: String
    let event_id: String
    let negative_points: Int
    let redo: Int
    let undo: Int
    let hint: Int
    let total_points: Int
    let submit_date: String
    let time_taken: String
    let category: String
    let first_name: String
    let last_name: String
}
