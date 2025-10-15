//
//  StartGameView.swift
//  Sudoku_SwiftUI
//
//  Created by Sai Babu on 13/10/25.


import SwiftUI
import Combine

struct SudokuGameView: View {
    @StateObject private var viewModel = SudokuGameViewModel()
    @ObservedObject var themeManager = ThemeManager.shared
    let level: String
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
//                themeManager.selectedTheme?.image?
//                    .resizable()
                Rectangle()
                    .fill(Color.blue)
                    .ignoresSafeArea()
                
                VStack(spacing: geometry.size.height * 0.03) {
                    if viewModel.isLoading {
                        ProgressView("Loading puzzle...")
                            .foregroundColor(.white)
                            .font(.title2)
                    } else if viewModel.puzzle != nil {
                        VStack(spacing: geometry.size.height * 0.015) {
                            // Tool buttons
                            VStack(spacing: geometry.size.height * 0.015) {
                                HStack(spacing: geometry.size.width * 0.05) {
                                    
                                    // Undo Button
                                    Button(action: { viewModel.undo() }) {
                                        ToolButton(systemName: "arrow.uturn.backward", size: geometry.size.width * 0.15)
                                    }
                                    .disabled(viewModel.remainingUndoLimit == 0)
                                    .opacity(viewModel.remainingUndoLimit == 0 ? 0.3 : 1)
                                    
                                    // Redo Button
                                    Button(action: { viewModel.redo() }) {
                                        ToolButton(systemName: "arrow.uturn.forward", size: geometry.size.width * 0.15)
                                    }
                                    .disabled(viewModel.remainingRedoLimit == 0)
                                    .opacity(viewModel.remainingRedoLimit == 0 ? 0.3 : 1)
                                    
                                    // Restart Button (always clickable)
                                    Button(action: { viewModel.restartGame() }) {
                                        ToolButton(systemName: "gobackward", size: geometry.size.width * 0.15)
                                    }
                                    
                                    // Hint Button
                                    ZStack(alignment: .topTrailing) {
                                        Button(action: { viewModel.useHint() }) {
                                            ToolButton(systemName: "lightbulb", size: geometry.size.width * 0.15)
                                        }
                                        .disabled(viewModel.remainingHintLimit == 0)
                                        .opacity(viewModel.remainingHintLimit == 0 ? 0.3 : 1)
                                        
                                        Text("\(viewModel.remainingHintLimit > 0 ? viewModel.remainingHintLimit : 0)")
                                            .font(.system(size: geometry.size.width * 0.05))
                                            .foregroundColor(.white)
                                            .padding(geometry.size.width * 0.01)
                                            .clipShape(Circle())
                                    }
                                    
                                    Button(action: { viewModel.toggleNoteMode() }) {
                                        ToolButton(
                                            systemName: "note.text",
                                            isActive: viewModel.isNoteMode,
                                            size: geometry.size.width * 0.15
                                        )
                                    }
                                }
                                Text(viewModel.puzzle?.category.description ?? "")
                                    .font(.system(size: geometry.size.width * 0.07))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, geometry.size.width * 0.04)
                                    .frame(height: geometry.size.height * 0.055)
                                    .background(Color.black.opacity(0.7))
                                    .cornerRadius(10)
                                    .frame(maxWidth: .infinity)
                                    .onTapGesture {
//                                        viewModel.stopTimer()
//                                        stopTimer()
//                                          
//                                           viewModel.submitCurrentGame(
//                                               riderID: 12334,
//                                               eventID: "",
//                                               puzzleDate: puzzleDate,
//                                               difficulty: selectedDifficulty,
//                                               firstName: firstName,
//                                               lastName: lastName
//                                           ) { success in
//                                               if success {
//                                                   // navigate to points screen
//                                               }
//                                           }
                                       }
                            }
                            
                            SudokuBoardView(
                                viewModel: viewModel,
                                grid: viewModel.workingGrid,
                                selectedRow: viewModel.selectedRow,
                                selectedCol: viewModel.selectedCol,
                                onCellTap: { row, col in viewModel.selectCell(row: row, col: col) },
                                screenSize: geometry.size
                            )
                            .frame(maxWidth: .infinity)
                            
                            NumberPadView(
                                viewModel: viewModel,
                                onNumberTap: { number in viewModel.insertNumber(number) },
                                screenSize: geometry.size
                            )
                            
                        }
                    } else if let error = viewModel.errorMessage {
                        Text("Error: \(error)")
                            .foregroundColor(.red)
                            .padding()
                    }
                }
            }
        }
        .task {
            await viewModel.fetchSudokuPuzzle(category: level)
        }
    }
}

struct SudokuBoardView: View {
    @ObservedObject var viewModel: SudokuGameViewModel
    let grid: [[Int]]
    let selectedRow: Int?
    let selectedCol: Int?
    let onCellTap: (Int, Int) -> Void
    let screenSize: CGSize
    
    var cellSize: CGFloat {
        min(screenSize.width * 0.95, screenSize.height * 0.5) / 8.2
    }
    
    var selectedValue: Int? {
        guard let row = selectedRow, let col = selectedCol else { return nil }
        return grid[row][col] == 0 ? nil : grid[row][col]
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(0..<9, id: \.self) { row in
                HStack(spacing: 0) {
                    ForEach(0..<9, id: \.self) { col in
                        let value = grid[row][col]
                        let isSelected = selectedRow == row && selectedCol == col
                        let isSameRowOrCol = (selectedRow == row) || (selectedCol == col)
                        let isInSameBox = isInSame3x3Box(row1: row, col1: col, row2: selectedRow, col2: selectedCol)
                        let matchesSelectedValue = selectedValue != nil && selectedValue == value && value != 0
                        let key = "\(row),\(col)"
                        SudokuCell(
                            value: value,
                            isSelected: isSelected,
                            isSameRowOrCol: isSameRowOrCol,
                            isInSameBox: isInSameBox,
                            matchesSelectedValue: matchesSelectedValue,
                            isEditable: value == 0,
                            isWrong: viewModel.isCellWrong(row: row, col: col),
                            onTap: { onCellTap(row, col) },
                            notes: viewModel.notes[key] ?? [],
                            isBlinking: viewModel.blinkingCells.contains(key),
                            cellSize: cellSize
                        )
                    }
                }
            }
        }
        .overlay(GridLines())
        .background(Color.white)
    }
    
    func isInSame3x3Box(row1: Int, col1: Int, row2: Int?, col2: Int?) -> Bool {
        guard let row2 = row2, let col2 = col2 else { return false }
        return (row1 / 3 == row2 / 3) && (col1 / 3 == col2 / 3)
    }
}

struct SudokuCell: View {
    let value: Int
    let isSelected: Bool
    let isSameRowOrCol: Bool
    let isInSameBox: Bool
    let matchesSelectedValue: Bool
    let isEditable: Bool
    let isWrong: Bool
    let onTap: () -> Void
    let notes: Set<Int>
    let isBlinking: Bool
    let cellSize: CGFloat
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(backgroundColor)
                .frame(width: cellSize, height: cellSize)
                .overlay(
                    RoundedRectangle(cornerRadius: 0)
                        .strokeBorder(isBlinking ? Color.red : Color.green,
                                      lineWidth: (isSelected || matchesSelectedValue || isBlinking) ? 3 : 0)
                        .animation(.easeInOut(duration: 0.3), value: isBlinking)
                )
            
            if value != 0 {
                Text("\(value)")
                    .font(.system(size: cellSize * 0.5, weight: .semibold))
                    .foregroundColor(cellColor)
            } else if !notes.isEmpty {
                VStack(spacing: cellSize * 0.02) {
                    let sortedNotes = Array(notes.sorted())
                    ForEach(0..<3, id: \.self) { row in
                        HStack(spacing: cellSize * 0.03) {
                            ForEach(0..<3, id: \.self) { col in
                                let index = row * 3 + col
                                if index < sortedNotes.count {
                                    Text("\(sortedNotes[index])")
                                        .font(.system(size: cellSize * 0.2))
                                        .foregroundColor(.gray)
                                        .frame(width: cellSize * 0.2, height: cellSize * 0.2)
                                } else {
                                    Text("")
                                        .frame(width: cellSize * 0.2, height: cellSize * 0.2)
                                }
                            }
                        }
                    }
                }
            }
        }
        .onTapGesture { onTap() }
    }
    
    private var backgroundColor: Color {
        if isSelected {
            return Color.gray.opacity(0.4)
        } else if isSameRowOrCol || isInSameBox {
            return Color.blue.opacity(0.2)
        } else {
            return ThemeManager.shared.selectedGridColor
        }
    }
    
    private var cellColor: Color {
        if isWrong {
            return .red
        } else {
            return isEditable ? .blue : .black
        }
    }
}

struct GridLines: View {
    var body: some View {
        GeometryReader { geo in
            Path { path in
                let size = geo.size
                let cellSize = size.width / 9
                
                for i in 0...9 {
                    let lineX = CGFloat(i) * cellSize
                    path.move(to: CGPoint(x: lineX, y: 0))
                    path.addLine(to: CGPoint(x: lineX, y: size.height))
                }
                
                for i in 0...9 {
                    let lineY = CGFloat(i) * cellSize
                    path.move(to: CGPoint(x: 0, y: lineY))
                    path.addLine(to: CGPoint(x: size.width, y: lineY))
                }
            }
            .stroke(Color.black, lineWidth: 0.5)
            .overlay(
                Path { path in
                    let size = geo.size
                    let cellSize = size.width / 9
                    for i in [3, 6] {
                        let pos = CGFloat(i) * cellSize
                        path.move(to: CGPoint(x: pos, y: 0))
                        path.addLine(to: CGPoint(x: pos, y: size.height))
                        path.move(to: CGPoint(x: 0, y: pos))
                        path.addLine(to: CGPoint(x: size.width, y: pos))
                    }
                }
                    .stroke(Color.black, lineWidth: 2)
            )
        }
    }
}

struct NumberPadView: View {
    @ObservedObject var viewModel: SudokuGameViewModel
    let onNumberTap: (Int) -> Void
    let screenSize: CGSize
    
    let numbers = [
        [1, 2, 3, 4, 5],
        [6, 7, 8, 9, 0]
    ]
    
    var buttonSize: CGFloat {
        min(screenSize.width * 1.6, screenSize.height * 0.085)
    }
    
    var body: some View {
        VStack(spacing: screenSize.height * 0.015) {
            ForEach(0..<numbers.count, id: \.self) { row in
                HStack(spacing: screenSize.width * 0.03) {
                    ForEach(numbers[row], id: \.self) { number in
                        Button(action: {
                            if number == 0 {
                                viewModel.deleteSelectedCell()
                            } else {
                                onNumberTap(number)
                            }
                        }) {
                            if number == 0 {
                                Image(systemName: "delete.left")
                                    .font(.system(size: buttonSize * 0.4))
                                    .foregroundColor(.white)
                                    .frame(width: buttonSize, height: buttonSize)
                                    .background(Color.black.opacity(viewModel.isDeleteEnabled ? 0.7 : 0.3))
                                    .cornerRadius(10)
                            } else {
                                Text("\(number)")
                                    .font(.system(size: buttonSize * 0.45))
                                    .foregroundColor(.white)
                                    .frame(width: buttonSize, height: buttonSize)
                                    .background(Color.black.opacity(
                                        viewModel.enabledNumbers.contains(number) ? 0.7 : 0.3
                                    ))
                                    .cornerRadius(10)
                            }
                        }
                        .disabled(number == 0 ? !viewModel.isDeleteEnabled : !viewModel.enabledNumbers.contains(number))
                    }
                }
            }
        }
    }
}

struct ToolButton: View {
    var systemName: String
    var isActive: Bool = false
    var isDisabled: Bool = false
    var size: CGFloat = 50
    
    var body: some View {
        Image(systemName: systemName)
            .font(.system(size: size * 0.45))
            .foregroundColor(isActive ? .yellow : .white)
            .frame(width: size, height: size)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(isActive ? Color.white.opacity(0.2) : Color.clear)
            )
            .opacity(isDisabled ? 0.3 : 1)  // visually dull
            .disabled(isDisabled)           // prevents tapping
    }
}



#Preview {
    SudokuGameView(level: "easy")
}



