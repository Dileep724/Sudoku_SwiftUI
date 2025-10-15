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
    @Published var enabledNumbers: Set<Int> = []
    @Published var isDeleteEnabled: Bool = false
    @Published var lockedCells: Set<String> = []
    @Published var isNoteMode: Bool = false
    @Published var notes: [String: Set<Int>] = [:]
    @Published var blinkingCell: String?
    @Published var blinkingCells: Set<String> = []
    private var tournamentID: String?
    
    @Published var elapsedTime: Int = 0
    @Published var hintsUsed: Int = 0
    @Published var undoCount: Int = 0
    @Published var redoCount: Int = 0
    @Published var wrongEntryCount: Int = 0
    private var timer: Timer?
    
    func fetchSudokuPuzzle(category: String) {
        isLoading = true
        errorMessage = nil
        
        let urlString = "https://zdotapps.in/carelon/sudoku/\(category)/"
        
        NetworkManager.shared.request(
            urlString: urlString,
            method: .GET,
            bodyType: .json,
            responseType: SudokuPuzzle.self
        ) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.isLoading = false
                
                switch result {
                case .success(let decodedPuzzle):
                    self.puzzle = decodedPuzzle
                    self.workingGrid = decodedPuzzle.puzzle
                    self.remainingUndoLimit = decodedPuzzle.undoLimit
                    self.remainingRedoLimit = decodedPuzzle.redoLimit
                    self.remainingHintLimit = decodedPuzzle.hintLimit
                    self.undoStack.removeAll()
                    self.redoStack.removeAll()
                    self.startTimer()
                    
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    print("❌ Network Error: \(error)")
                }
            }
        }
    }
    func startTimer() {
        timer?.invalidate()
        elapsedTime = 0
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.elapsedTime += 1
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    func submitCurrentGame(riderID: Int,
                           eventID: String,
                           puzzleDate: String,
                           difficulty: String,
                           firstName: String,
                           lastName: String,
                           completion: @escaping (Bool) -> Void) {
        
        let (totalScore, timeBonus) = calculateTotalScore(forDifficulty: difficulty)
        var totalPoints = totalScore
//        let streakBonusApplied = applyStreakBonus(score: &totalPoints, puzzleDate: puzzleDate)
        
        let body: [String: Any] = [
            "rider_id": String(riderID),
            "event_id": eventID,
            "negative_points": wrongEntryCount * 1,
            "redo": redoCount,
            "undo": undoCount,
            "hint": hintsUsed,
            "total_points": totalPoints,
            "submit_date": puzzleDate,
            "time_taken": formatTimeForTournament(seconds: elapsedTime),
            "category": difficulty.capitalized,
            "first_name": firstName.capitalized,
            "last_name": lastName.capitalized
        ]
        
        NetworkManager.shared.request(
            urlString: "https://zdotapps.in/carelon/sudokuresults/",
            method: .POST,
            parameters: body,
            bodyType: .json,
            responseType: BasicResponse.self
        ) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    print("✅ Game submitted: \(response.message)")
                    completion(true)
                case .failure(let error):
                    print("❌ Submit failed: \(error)")
                    completion(false)
                }
            }
        }
    }
    
    
    private func formatTimeForTournament(seconds: Int) -> String {
        let minutes = seconds / 60
        let secs = seconds % 60
        return String(format: "%02d:%02d", minutes, secs)
    }
    
    
    func toggleNoteMode() {
        isNoteMode.toggle()
    }
    
    
    func selectCell(row: Int, col: Int) {
        selectedRow = row
        selectedCol = col
        let key = "\(row),\(col)"
        
        if puzzle?.puzzle[row][col] != 0 || lockedCells.contains(key) {
            enabledNumbers = []
            isDeleteEnabled = false
            return
        }
        isDeleteEnabled = workingGrid[row][col] != 0 || (notes[key]?.isEmpty == false)
        
        enabledNumbers = Set(1...9).subtracting(disabledCompletedNumbers())
    }
    
    
    
    
    func insertNumber(_ number: Int) {
        guard let row = selectedRow, let col = selectedCol else { return }
        guard puzzle?.puzzle[row][col] == 0 else { return }
        let key = "\(row),\(col)"
        guard !lockedCells.contains(key) else { return }
        
        if isNoteMode {
            handleNoteEntry(number, at: key, row: row, col: col)
            return
        }
        
        saveStateForUndo()
        workingGrid[row][col] = number
        redoStack.removeAll()
        updateNumberUsage()
        updateCorrectNumbers()
        
        if isCellWrong(row: row, col: col) {
            wrongEntryCount += 1  // ✅ Count mistakes
            enabledNumbers = Set(1...9).subtracting(disabledCompletedNumbers())
            isDeleteEnabled = true
        } else {
            lockedCells.insert(key)
            enabledNumbers = []
            isDeleteEnabled = false
        }
        
        disableCompletedNumbers()
    }
    
    func calculateTotalScore(forDifficulty difficulty: String) -> (score: Int, timeBonus: Int) {
        var totalScore = 100
        var timeBonus = 0
        
        switch difficulty {
        case "Beginner": timeBonus = elapsedTime < 240 ? 10 : 0
        case "Easy":     timeBonus = elapsedTime < 300 ? 10 : 0
        case "Medium":   timeBonus = elapsedTime < 360 ? 10 : 0
        case "Hard":     timeBonus = elapsedTime < 420 ? 10 : 0
        case "Expert":   timeBonus = elapsedTime < 480 ? 10 : 0
        default:         timeBonus = 0
        }
        
        totalScore += timeBonus
        totalScore -= (hintsUsed * 3) + (redoCount * 1) + (undoCount * 1) + (wrongEntryCount * 2)
        totalScore = max(totalScore, 0)
        
        return (totalScore, timeBonus)
    }
 
    func handleNoteEntry(_ number: Int, at key: String, row: Int, col: Int) {
        let conflictingKeys = conflictingCellsFor(number, row: row, col: col)
        
        if !conflictingKeys.isEmpty {
            blinkCells(conflictingKeys)
            return
        }
        
        var cellNotes = notes[key] ?? []
        if cellNotes.contains(number) {
            cellNotes.remove(number)
        } else {
            cellNotes.insert(number)
        }
        notes[key] = cellNotes
        isDeleteEnabled = !cellNotes.isEmpty
    }
    
    
    func conflictingCellsFor(_ number: Int, row: Int, col: Int) -> [String] {
        var conflicts: [String] = []
        
        // Row
        for c in 0..<9 where workingGrid[row][c] == number {
            conflicts.append("\(row),\(c)")
        }
        
        // Column
        for r in 0..<9 where workingGrid[r][col] == number {
            conflicts.append("\(r),\(col)")
        }
        
        // 3x3 Box
        let startRow = (row / 3) * 3
        let startCol = (col / 3) * 3
        for r in startRow..<(startRow + 3) {
            for c in startCol..<(startCol + 3) {
                if workingGrid[r][c] == number {
                    conflicts.append("\(r),\(c)")
                }
            }
        }
        
        return conflicts
    }
    func blinkCells(_ keys: [String]) {
        blinkingCells = Set(keys)
        Task {
            try? await Task.sleep(nanoseconds: 300_000_000)
            blinkingCells = []
            try? await Task.sleep(nanoseconds: 300_000_000)
            blinkingCells = Set(keys)
            try? await Task.sleep(nanoseconds: 300_000_000)
            blinkingCells = []
        }
    }
    
    func numberExistsInRowColOrBox(_ number: Int, row: Int, col: Int) -> Bool {
        // Row
        if workingGrid[row].contains(number) { return true }
        
        // Column
        for r in 0..<9 where workingGrid[r][col] == number {
            return true
        }
        
        // 3x3 Box
        let startRow = (row / 3) * 3
        let startCol = (col / 3) * 3
        for r in startRow..<(startRow + 3) {
            for c in startCol..<(startCol + 3) {
                if workingGrid[r][c] == number {
                    return true
                }
            }
        }
        return false
    }
    
    func blinkCell(row: Int, col: Int) {
        let key = "\(row),\(col)"
        blinkingCell = key
        Task {
            try? await Task.sleep(nanoseconds: 300_000_000)
            blinkingCell = nil
        }
    }
    
    func disabledCompletedNumbers() -> Set<Int> {
        guard let solution = puzzle?.solution else { return [] }
        var completed: Set<Int> = []
        
        for num in 1...9 {
            var correctCount = 0
            for r in 0..<9 {
                for c in 0..<9 {
                    if workingGrid[r][c] == num && workingGrid[r][c] == solution[r][c] {
                        correctCount += 1
                    }
                }
            }
            if correctCount == 9 {
                completed.insert(num)
            }
        }
        return completed
    }
    func disableCompletedNumbers() {
        let completed = disabledCompletedNumbers()
        enabledNumbers.subtract(completed)
    }
    
    
    func deleteSelectedCell() {
        guard let row = selectedRow, let col = selectedCol else { return }
        let key = "\(row),\(col)"
        guard puzzle?.puzzle[row][col] == 0 else { return }
        guard !lockedCells.contains(key) else { return }
        
        // Clear notes first
        if let cellNotes = notes[key], !cellNotes.isEmpty {
            notes[key] = []
            isDeleteEnabled = true // keep enabled for the value
            return
        }
        
        workingGrid[row][col] = 0
        enabledNumbers = Set(1...9).subtracting(disabledCompletedNumbers())
        isDeleteEnabled = false
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
        undoCount += 1
    }
    
    func redo() {
        guard remainingRedoLimit > 0, let nextState = redoStack.popLast() else { return }
        undoStack.append(workingGrid)
        workingGrid = nextState
        remainingRedoLimit -= 1
        redoCount += 1
    }
    
    
    func restartGame() {
        guard let original = puzzle?.puzzle else { return }
        workingGrid = original
        undoStack.removeAll()
        redoStack.removeAll()
        remainingUndoLimit = puzzle?.undoLimit ?? 0
        remainingRedoLimit = puzzle?.redoLimit ?? 0
        remainingHintLimit = puzzle?.hintLimit ?? 0
        selectedRow = nil
        selectedCol = nil
        notes.removeAll()
        blinkingCell = nil
        blinkingCells.removeAll()
        enabledNumbers.removeAll()
        isDeleteEnabled = false
        lockedCells.removeAll()
        correctNumbers.removeAll()
        isNoteMode = false
        numberUsage.removeAll()
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
        hintsUsed += 1
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
    
    private func saveStateForUndo() {
        undoStack.append(workingGrid)
        if undoStack.count > (puzzle?.undoLimit ?? 10) {
            undoStack.removeFirst()
        }
    }
}


