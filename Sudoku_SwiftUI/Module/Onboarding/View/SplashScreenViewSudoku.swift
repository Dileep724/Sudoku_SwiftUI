//
//  SplashScreenViewSudoku.swift
//  Sudoku_SwiftUI
//
//  Created by Dileep Kumar on 10/10/25.
//

import SwiftUI

// MARK: - Splash Screen View

struct SplashScreenViewSudoku: View {
    
    // MARK: - Properties
    
    @StateObject private var viewModel = SplashScreenModel()
    
    // MARK: - View
    
    var body: some View {
        NavigationView {
            ZStack {
                Image("Bamboo Zen")
                    .resizable()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .ignoresSafeArea()
                
                VStack(spacing: 25) {
                    Image("Splashscreenimage")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150)
                        .rotationEffect(.degrees(-15))
                    
                    Text("SUDOKU")
                        .font(.system(size: 40))
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                    
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: 300, height: 20)
                            .foregroundColor(Color.white)
                        
                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: 300 * viewModel.progress, height: 20)
                            .foregroundColor(Color(red: 19/255, green: 224/255, blue: 139/255))
                            .animation(.linear(duration: 0.1), value: viewModel.progress)
                    }// ZStack
                }// VStack
                
                NavigationLink(destination: MenuView(), isActive: $viewModel.navigateToMenu) {
                    EmptyView()
                }
                .hidden()
            }// ZStack
            .ignoresSafeArea()
        }// NavigationView
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear {
            viewModel.startProgressAnimation()
        }
    }
}

// MARK: - Preview

#Preview {
    SplashScreenViewSudoku()
}
