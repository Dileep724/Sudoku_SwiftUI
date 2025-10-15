//
//  DifficultyPopupView.swift
//  Sudoku_SwiftUI
//
//  Created by Sai Babu on 13/10/25.
//

import SwiftUI

struct DifficultyPopupView: View {
    @Binding var isPresented: Bool
    var onSelectLevel: (String) -> Void  // <-- new closure
    
    var body: some View {
        ZStack {
            Color.black.opacity(0)
                .ignoresSafeArea()
                .onTapGesture {
                    withAnimation { isPresented = false }
                }
            
            VStack(spacing: 16) {
                HStack {
                    Text("Choose Difficulty")
                        .font(.headline)
                        .fontWeight(.semibold)
                    Spacer()
                    Button {
                        withAnimation { isPresented = false }
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundColor(.gray)
                            .font(.system(size: 16, weight: .bold))
                    }
                }
                
                VStack(spacing: 12) {
                    ForEach(["beginner","easy","medium","hard","expert"], id: \.self) { level in
                        DifficultyButton(title: level) {
                            onSelectLevel(level) 
                            withAnimation { isPresented = false }
                        }
                    }
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
    DifficultyPopupView(isPresented: .constant(true)) { selectedLevel in
        // For preview, you can just print the level or do nothing
        print("Selected level: \(selectedLevel)")
    }
}

