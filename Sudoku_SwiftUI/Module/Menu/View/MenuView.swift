//
//  MenuView.swift
//  Sudoku_SwiftUI
//
//  Created by Dileep Kumar on 10/10/25.
//

import SwiftUI

// MARK: - Menu View

struct MenuView: View {
    
    // MARK: - Properties
    
    @StateObject var viewModel = MenuModel()
    @ObservedObject var themeManager = ThemeManager.shared
    
    // MARK: - View
    
    var body: some View {
        ZStack {
            themeManager.selectedTheme?.image?
                .resizable()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                Spacer()
                
                VStack(spacing: 20) {
                    Button("START GAME") {
                        viewModel.moveToStartGame()
                    }
                    .buttonStyle(MenuButtonStyle())
                    
                    Button("TIPS") {
                        viewModel.moveToTips()
                    }
                    .buttonStyle(MenuButtonStyle())
                    
                    Button("THEMES") {
                        viewModel.moveToThemes()
                    }
                    .buttonStyle(MenuButtonStyle())
                    
                    Button("SCORE BOARD") {
                        viewModel.moveToMyScoreBoard()
                    }
                    .buttonStyle(MenuButtonStyle())
                }// VStack
                .padding(.horizontal, 40)
                Spacer()
                
                NavigationLink(destination: MyScoreBoardView(), isActive: $viewModel.goToScoreBoard) {
                    EmptyView()
                }
                .hidden()
            }// VStack
 
            if viewModel.showDifficultyPopup {
                Color.black.opacity(0)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation {
                            viewModel.showDifficultyPopup = false
                        }
                    }
                
                DifficultyPopupView(isPresented: $viewModel.showDifficultyPopup)
                    .transition(.scale.combined(with: .opacity))
                    .zIndex(1)
            }
        }// ZStack
        
        .fullScreenCover(isPresented: $viewModel.goToThemes) {
            ThemesView(viewModel: ThemesViewModel())
        }
        .navigationBarHidden(true)
        .animation(.easeInOut(duration: 0.3), value: viewModel.showDifficultyPopup)
    }
}

// MARK: - Preview

#Preview {
    NavigationView {
        MenuView()
    }
}

