//
//  InstructionsView.swift
//  Sudoku_SwiftUI
//
//  Created by Dileep Kumar on 15/10/25.
//

import SwiftUI

// MARK: - Instructions View

struct InstructionsView: View {
    
    // MARK: - Properties
    
    @ObservedObject var themeManager = ThemeManager.shared
    @StateObject private var viewModel = InstructionsViewModel()
    
    var body: some View {
        ZStack {
            (themeManager.selectedTheme?.image ?? Image("Bamboo Zen"))
                .resizable()
                .frame(width: .infinity, height: .infinity)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
        
                HStack {
                    Text(viewModel.title.isEmpty ? "SUDOKU" : viewModel.title)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                }// HStack
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(.white)
                .cornerRadius(8)
                .padding(.top, 30)
                .padding(.horizontal)
        
                ScrollView {
                    VStack(spacing: 16) {
                        if viewModel.isLoading {
                            ProgressView("Loading Instructions...")
                                .padding(.top, 40)
                        } else if let error = viewModel.errorMessage {
                            Text(error)
                                .foregroundColor(.red)
                                .multilineTextAlignment(.center)
                                .padding()
                        } else {
                            ForEach(viewModel.instructions) { item in
                                InstructionCard(item: item)
                            }
                        }
                    }// VStack
                    .padding(.horizontal)
                    .padding(.bottom, 30)
                }// Scroll View
            }// VStack
        }// ZStack
        .onAppear {
            viewModel.fetchInstructions()
        }
    }
}

// MARK: - Preview

#Preview {
    InstructionsView()
}
