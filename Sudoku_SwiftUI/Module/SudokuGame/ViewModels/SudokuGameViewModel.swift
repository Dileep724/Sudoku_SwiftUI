//
//  SudokuGameViewModel.swift
//  Sudoku_SwiftUI
//
//  Created by Sai Babu on 14/10/25.
//
import Foundation
import Combine

@MainActor
class SudokuGameViewModel: ObservableObject {
    @Published var puzzle: SudokuPuzzle?
    @Published var workingGrid: [[Int]] = []
    @Published var selectedRow: Int?
    @Published var selectedCol: Int?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    // MARK: - New State
    private var undoStack: [[[Int]]] = []
    private var redoStack: [[[Int]]] = []
    
    @Published var remainingUndoLimit = 0
    @Published var remainingRedoLimit = 0
    @Published var remainingHintLimit = 0
    @Published var numberUsage: [Int: Int] = [:]
    @Published var correctNumbers: Set<Int> = []

    // MARK: - Fetch
    func fetchSudokuPuzzle(Category: String) async {
        guard let url = URL(string: "https://zdotapps.in/carelon/sudoku/easy/") else { return }
        isLoading = true
        errorMessage = nil
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decodedPuzzle = try JSONDecoder().decode(SudokuPuzzle.self, from: data)
            self.puzzle = decodedPuzzle
            self.workingGrid = decodedPuzzle.puzzle
            
            // Assign limits from backend
            self.remainingUndoLimit = decodedPuzzle.undoLimit
            self.remainingRedoLimit = decodedPuzzle.redoLimit
            self.remainingHintLimit = decodedPuzzle.hintLimit
            
            undoStack.removeAll()
            redoStack.removeAll()
            
            isLoading = false
        } catch {
            self.errorMessage = error.localizedDescription
            isLoading = false
        }
    }
    
    // MARK: - Cell Interaction
    func selectCell(row: Int, col: Int) {
        selectedRow = row
        selectedCol = col
    }

    func insertNumber(_ number: Int) {
        guard let row = selectedRow, let col = selectedCol else { return }
        guard puzzle?.puzzle[row][col] == 0 else { return } // Only editable cells
        
        saveStateForUndo()
        workingGrid[row][col] = number
        redoStack.removeAll()
        
        updateNumberUsage() // <-- call this
    }

    
    func isCellWrong(row: Int, col: Int) -> Bool {
        guard let solution = puzzle?.solution else { return false }
        let value = workingGrid[row][col]
        return value != 0 && puzzle?.puzzle[row][col] == 0 && value != solution[row][col]
    }

    func undo() {
        guard remainingUndoLimit > 0, let lastState = undoStack.popLast() else { return }
        redoStack.append(workingGrid)
        workingGrid = lastState
        remainingUndoLimit -= 1
    }
    
    func redo() {
        guard remainingRedoLimit > 0, let nextState = redoStack.popLast() else { return }
        undoStack.append(workingGrid)
        workingGrid = nextState
        remainingRedoLimit -= 1
    }
    
    func restartGame() {
        guard let original = puzzle?.puzzle else { return }
        workingGrid = original
        undoStack.removeAll()
        redoStack.removeAll()
        remainingUndoLimit = puzzle?.undoLimit ?? 0
        remainingRedoLimit = puzzle?.redoLimit ?? 0
    }
    
    func useHint() {
        guard remainingHintLimit > 0 else { return }
        guard let row = selectedRow, let col = selectedCol else { return }
        guard let solution = puzzle?.solution else { return }
        guard workingGrid[row][col] == 0 else { return }
        
        saveStateForUndo()
        workingGrid[row][col] = solution[row][col]
        remainingHintLimit -= 1
        redoStack.removeAll()
    }
    func updateCorrectNumbers() {
        guard let solution = puzzle?.solution else { return }
        var correctSet: Set<Int> = []
        for row in 0..<9 {
            for col in 0..<9 {
                let value = workingGrid[row][col]
                if value != 0 && value == solution[row][col] {
                    correctSet.insert(value)
                }
            }
        }
        correctNumbers = correctSet
    }
    func updateNumberUsage() {
        var usage: [Int: Int] = [:]
        for row in workingGrid {
            for value in row where value != 0 {
                usage[value, default: 0] += 1
            }
        }
        numberUsage = usage
    }
    // MARK: - Helpers
    private func saveStateForUndo() {
        undoStack.append(workingGrid)
        if undoStack.count > (puzzle?.undoLimit ?? 10) {
            undoStack.removeFirst() // keep only within limit
        }
    }
}
