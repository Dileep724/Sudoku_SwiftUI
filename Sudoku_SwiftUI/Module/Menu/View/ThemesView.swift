//
//  ThemesView.swift
//  Sudoku_SwiftUI
//
//  Created by Dileep Kumar on 10/10/25.
//

import SwiftUI
import Combine

struct ThemesView: View {
    
    // MARK: - Properties
    
    @ObservedObject var viewModel: ThemesViewModel
    @ObservedObject var themeManager = ThemeManager.shared
    @Environment(\.dismiss) private var dismiss
    @State private var isLoading = true
    
    // MARK: - View
    
    var body: some View {
        ZStack {
            themeManager.selectedTheme?.image?
                .resizable()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                ZStack(alignment: .topTrailing) {
                    
                    VStack(alignment: .leading, spacing: 20) {
                        
                        Text("Background Style")
                            .font(.system(size: 25))
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                            .padding(.horizontal, 20)
                            .padding(.top, 20)
                        
                        ZStack {
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color(red: 5/255, green: 5/255, blue: 5/255).opacity(0.65),
                                    Color(red: 24/255, green: 93/255, blue: 222/255).opacity(0.53)
                                ]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                            .cornerRadius(15)
                            
                            if isLoading {
                                ProgressView()
                                    .frame(height: 190)
                            } else {
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 20) {
                                        ForEach(viewModel.themes) { theme in
                                            VStack(spacing: 8) {
                                                Text(theme.name)
                                                    .font(.headline)
                                                    .foregroundColor(.black)
                                                
                                                ZStack {
                                                    RoundedRectangle(cornerRadius: 15)
                                                        .fill(Color.white)
                                                        .shadow(radius: 5)
                                                        .frame(width: 150, height: 150)
                                                    
                                                    theme.image?
                                                        .resizable()
                                                        .scaledToFill()
                                                        .frame(width: 150, height: 150)
                                                        .clipped()
                                                        .cornerRadius(12)
                                                        .overlay(
                                                            RoundedRectangle(cornerRadius: 12)
                                                                .stroke(
                                                                    themeManager.selectedTheme?.id == theme.id ? Color.black : Color.clear,
                                                                    lineWidth: 2
                                                                )
                                                        )
                                                }// ZStack
                                            }// VStack
                                            .onTapGesture {
                                                themeManager.selectedTheme = theme
                                            }
                                        }
                                    }
                                    .padding(.horizontal, 15)
                                    .padding(.vertical, 20)
                                } // Scroll View
                                .frame(height: 190)
                            }// Scroll View
                        }// ZStack
                        .frame(height: 190)
                        .padding(.horizontal, 10)
                        .padding(.bottom, 10)
                        
                        VStack(alignment: .leading, spacing: 20) {
                            
                            Text("Grid Style")
                                .font(.system(size: 25))
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                                .padding(.horizontal, 20)
                                .padding(.top, 10)
                            
                            ZStack {
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        Color(red: 5/255, green: 5/255, blue: 5/255).opacity(0.65),
                                        Color(red: 24/255, green: 93/255, blue: 222/255).opacity(0.53)
                                    ]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                                .cornerRadius(15)
                                
                                if isLoading {
                                    ProgressView()
                                        .frame(height: 190)
                                } else {
                                    ScrollView(.horizontal, showsIndicators: false) {
                                        HStack(spacing: 20) {
                                            ForEach(viewModel.gridOptions) { option in
                                                VStack(spacing: 8) {
                                                    option.image?
                                                        .resizable()
                                                        .scaledToFill()
                                                        .frame(width: 150, height: 150)
                                                        .clipped()
                                                        .cornerRadius(12)
                                                        .shadow(radius: 5)
                                                        .overlay(
                                                            RoundedRectangle(cornerRadius: 12)
                                                                .stroke(
                                                                    themeManager.selectedGridColor == option.color
                                                                    ? Color.black
                                                                    : Color.clear,
                                                                    lineWidth: 3
                                                                )
                                                        )
                                                }// VStack
                                                .onTapGesture {
                                                    withAnimation {
                                                        viewModel.selectGridOption(option)
                                                    }
                                                }
                                            }
                                        }// HStack
                                        .padding(.horizontal, 15)
                                        .padding(.vertical, 20)
                                    } // Scroll View
                                    .frame(height: 190)
                                } // Scroll View
                            }// ZStack
                            .frame(height: 190)
                            .padding(.horizontal, 10)
                            .padding(.bottom, 20)
                        }// VStack
                    }// VStack
                    .padding(.horizontal, 1)
                    .padding(.vertical, 8)
                    .background(Color.white)
                    .cornerRadius(20)
                    .shadow(radius: 10)
                    
                    Button(action: {
                        dismiss()
                        viewModel.closeThemesView()
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                            .font(.system(size: 24, weight: .bold))
                            .padding([.top, .trailing], 10)
                    }
                }// ZStack
                .padding(.horizontal, 15)
                .padding(.vertical, 10)
                
                Spacer()
            }// VStack
        }// ZStack
        .onAppear {
            viewModel.$themes
                .filter { !$0.isEmpty }
                .first()
                .sink { _ in
                    isLoading = false
                }
                .store(in: &viewModel.cancellables)
        }
    }
}

// MARK: - Preview

#Preview {
    ThemesView(viewModel: ThemesViewModel())
}
