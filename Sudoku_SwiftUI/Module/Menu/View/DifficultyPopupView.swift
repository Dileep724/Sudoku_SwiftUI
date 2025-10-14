//
//  DifficultyPopupView.swift
//  Sudoku_SwiftUI
//
//  Created by Sai Babu on 13/10/25.
//

import SwiftUI

struct DifficultyPopupView: View {
    @Binding var isPresented: Bool
    
    var body: some View {
        ZStack {
            // Background dim layer
            Color.black.opacity(0)
                .ignoresSafeArea()
                .onTapGesture {
                    withAnimation {
                        isPresented = false
                    }
                }
            
            // Popup Card
            VStack(spacing: 16) {
                
                // Header with title and close button
                HStack {
                    Text("Choose Difficulty")
                        .font(.headline)
                        .fontWeight(.semibold)
                    Spacer()
                    Button {
                        withAnimation {
                            isPresented = false
                        }
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundColor(.gray)
                            .font(.system(size: 16, weight: .bold))
                    }
                }
                .padding(.bottom, 4)
                
                // Difficulty Buttons
                VStack(spacing: 12) {
                    DifficultyButton(title: "Beginner") { startGame(level: "Beginner") }
                    DifficultyButton(title: "Easy") { startGame(level: "Easy") }
                    DifficultyButton(title: "Medium") { startGame(level: "Medium") }
                    DifficultyButton(title: "Hard") { startGame(level: "Hard") }
                    DifficultyButton(title: "Expert") { startGame(level: "Expert") }
                }
            }
            .padding(20)
            .frame(width: 350)
            .background(Color.white)
            .cornerRadius(16)
            .shadow(radius: 10)
        }
        .transition(.scale.combined(with: .opacity))
        .animation(.easeInOut, value: isPresented)
    }
    
    // MARK: - Actions
    func startGame(level: String) {
        print("Selected difficulty: \(level)")
        withAnimation {
            isPresented = false
        }
    }
}

// MARK: - Difficulty Button Component
struct DifficultyButton: View {
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 15)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.gray.opacity(0.8), Color.blue.opacity(0.8)]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(12)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    DifficultyPopupView(isPresented: .constant(true))
}
