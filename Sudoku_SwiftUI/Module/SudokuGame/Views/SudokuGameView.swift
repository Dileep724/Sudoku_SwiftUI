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
    
    var body: some View {
        ZStack {
            Image(themeManager.selectedTheme.imageName)
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            if viewModel.isLoading {
                ProgressView("Loading puzzle...")
                    .foregroundColor(.white)
                    .font(.title2)
            } else if viewModel.puzzle != nil {
                VStack {
                    VStack(spacing: 20) {
                        
                        HStack(spacing: 55) {
                            Button(action: { viewModel.undo() }) {
                                ToolButton(systemName: "arrow.uturn.backward")
                            }
                            .disabled(viewModel.remainingUndoLimit == 0)

                            Button(action: { viewModel.redo() }) {
                                ToolButton(systemName: "arrow.uturn.forward")
                            }
                            .disabled(viewModel.remainingRedoLimit == 0)

                            Button(action: { viewModel.restartGame() }) {
                                ToolButton(systemName: "gobackward")
                            }

                            Button(action: { viewModel.useHint() }) {
                                ToolButton(systemName: "lightbulb")
                            }
                            .disabled(viewModel.remainingHintLimit == 0)

                            ToolButton(systemName: "pencil")
                        }

                        
                        Text(viewModel.puzzle?.category.description ?? "")
                            .font(.title)
                            .foregroundColor(.white)
                            .padding(.horizontal, 20)
                            .frame(height: 40)
                            .background(Color.black.opacity(0.7))
                            .cornerRadius(10)
                            .frame(maxWidth: .infinity)
                    }

                    SudokuBoardView(
                        viewModel: viewModel,
                        grid: viewModel.workingGrid,
                        selectedRow: viewModel.selectedRow,
                        selectedCol: viewModel.selectedCol,
                        onCellTap: { row, col in
                            viewModel.selectCell(row: row, col: col)
                        }
                    )
                    .padding(.horizontal, 50)


                    NumberPadView(viewModel: viewModel, onNumberTap: { number in
                        viewModel.insertNumber(number)
                    })
                    .padding(.top, 30)


                    Spacer()
                }
                .padding(.top, 50)
            } else if let error = viewModel.errorMessage {
                Text("Error: \(error)")
                    .foregroundColor(.red)
                    .padding()
            }
        }
        .task {
            await viewModel.fetchSudokuPuzzle(Category: "")
        }
    }
}

struct SudokuBoardView: View {
    @ObservedObject var viewModel: SudokuGameViewModel   // <-- add this
    let grid: [[Int]]
    let selectedRow: Int?
    let selectedCol: Int?
    let onCellTap: (Int, Int) -> Void

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
                        let isSameRow = selectedRow == row
                        let isSameCol = selectedCol == col
                        let isInSameBox = isInSame3x3Box(row1: row, col1: col, row2: selectedRow, col2: selectedCol)
                        let matchesSelectedValue = selectedValue != nil && selectedValue == value && value != 0

                        SudokuCell(
                            value: value,
                            isSelected: isSelected,
                            isSameRowOrCol: isSameRow,
                            isInSameBox: isInSameBox,
                            matchesSelectedValue: matchesSelectedValue,
                            isEditable: value == 0,
                            isWrong: viewModel.isCellWrong(row: row, col: col), // now works
                            onTap: { onCellTap(row, col) }
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
    let isWrong: Bool  // <-- NEW
    let onTap: () -> Void
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(backgroundColor)
                .frame(width: 44, height: 44)
                .border(Color.black.opacity(0.2), width: 0.1)
                .overlay(
                    RoundedRectangle(cornerRadius: 0)
                        .inset(by: 0.5)
                        .strokeBorder(Color.green, lineWidth: (isSelected || matchesSelectedValue) ? 3 : 0)
                )
            
            if value != 0 {
                Text("\(value)")
                    .font(.title)
                    .fontWeight(.semibold)
                    .foregroundColor(cellColor)
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
            return Color.white
        }
    }
    
    private var cellColor: Color {
        if isWrong {
            return .red // Wrong number -> red
        } else {
            return isEditable ? .blue : .black // Correct numbers normal
        }
    }
}



struct GridLines: View {
    var body: some View {
        GeometryReader { geo in
            Path { path in
                let size = geo.size
                let cellSize = size.width / 9
                
                // Draw vertical bold lines every 3 columns
                for i in 0...9 {
                    let lineX = CGFloat(i) * cellSize
                    path.move(to: CGPoint(x: lineX, y: 0))
                    path.addLine(to: CGPoint(x: lineX, y: size.height))
                }
                
                // Draw horizontal bold lines every 3 rows
                for i in 0...9 {
                    let lineY = CGFloat(i) * cellSize
                    path.move(to: CGPoint(x: 0, y: lineY))
                    path.addLine(to: CGPoint(x: size.width, y: lineY))
                }
            }
            .stroke(Color.black, lineWidth: 0.5)
            .overlay(
                // Overlay thick 3x3 lines
                Path { path in
                    let size = geo.size
                    let cellSize = size.width / 9
                    for i in [0, 3, 6, 9] {
                        let pos = CGFloat(i) * cellSize
                        // Vertical
                        path.move(to: CGPoint(x: pos, y: 0))
                        path.addLine(to: CGPoint(x: pos, y: size.height))
                        // Horizontal
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
    
    let numbers = [
        [1, 2, 3, 4, 5],
        [6, 7, 8, 9, 0] 
    ]
    
    var body: some View {
          VStack(spacing: 15) {
              ForEach(0..<numbers.count, id: \.self) { row in
                  HStack(spacing: 15) {
                      ForEach(numbers[row], id: \.self) { number in
                          Button(action: {
                              onNumberTap(number)
                          }) {
                              if number == 0 {
                                  Image(systemName: "delete.left")
                                      .font(.title)
                                      .foregroundColor(.white)
                                      .frame(width: 65, height: 65)
                                      .background(Color.black.opacity(0.5))
                                      .cornerRadius(10)
                              } else {
                                  Text("\(number)")
                                      .font(.title)
                                      .foregroundColor(.white)
                                      .frame(width: 65, height: 65)
                                      .background(Color.black.opacity(0.5))
                                      .cornerRadius(10)
                              }
                          }
                      }
                  }
              }
          }
      }

  }


struct ToolButton: View {
    var systemName: String
    
    var body: some View {
        Image(systemName: systemName)
            .font(.title2)
            .foregroundColor(.white)
    }
}

#Preview {
    SudokuGameView()
}



