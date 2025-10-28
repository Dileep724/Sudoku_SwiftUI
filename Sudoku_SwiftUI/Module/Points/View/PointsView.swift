//
//  PointsView.swift
//  Sudoku_SwiftUI
//
//  Created by Dileep Kumar on 15/10/25.
//

import SwiftUI

// MARK: - Points View

struct PointsView: View {
    
    // MARK: - Properties
    
    @ObservedObject var themeManager = ThemeManager.shared
    @StateObject var viewModel = PointsViewModel()
    let maxPoints: CGFloat = 100
    
    var body: some View {
        ZStack {
            (themeManager.selectedTheme?.image ?? Image("Bamboo Zen"))
                .resizable()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text("SUDOKU")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.top, 30)
                ScrollView {
                    VStack(spacing: 12) {
                        HStack(spacing: 12) {
                            StarShape()
                                .fill(Color(red: 19/255, green: 224/255, blue: 139/255))
                                .frame(width: 60, height: 60)
                                .rotationEffect(.degrees(viewModel.rotateStar ? 360 : 0))
                                .animation(Animation.linear(duration: 2).repeatForever(autoreverses: false), value: viewModel.rotateStar)
                                .onAppear { viewModel.rotateStar = true }
                            
                            HStack(spacing: 4) {
                                Text(String(viewModel.gamePoints))
                                    .font(.system(size: 30))
                                    .foregroundColor(Color(UIColor(red: 19/255, green: 224/255, blue: 139/255, alpha: 1.0)))
                                Text("PTS")
                                    .font(.system(size: 16))
                                    .foregroundColor(Color(UIColor(red: 19/255, green: 224/255, blue: 139/255, alpha: 1.0)))
                                    .baselineOffset(-5)
                            }// HStack
                        }// Hstack
                        HStack(spacing: 4) {
                            Text("TOTAL SCORE : ")
                                .font(.system(size: 25))
                                .foregroundColor(Color(UIColor(red: 19/255, green: 224/255, blue: 139/255, alpha: 1.0)))
                            Text(String(viewModel.totalPoints))
                                .font(.system(size: 25))
                                .foregroundColor(Color(UIColor(red: 19/255, green: 224/255, blue: 139/255, alpha: 1.0)))
                        }// HStack
                        Text(viewModel.difficultyLevel)
                            .font(.system(size: 25))
                            .foregroundColor(Color(UIColor(red: 19/255, green: 224/255, blue: 139/255, alpha: 1.0)))
                        
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 10)
                                .frame(width: 300, height: 20)
                                .foregroundColor(Color.gray)
                            
                            RoundedRectangle(cornerRadius: 10)
                                .frame(width: 300 * CGFloat(viewModel.gamePoints) / maxPoints, height: 20)
                                .foregroundColor(Color(red: 19/255, green: 224/255, blue: 139/255))
                                .animation(.linear(duration: 0.1), value: viewModel.gamePoints)
                        }// ZStack
                        VStack(spacing: 5) {
                            HStack {
                                Text("TIME BONUS")
                                    .padding(.leading, 10)
                                    .font(.system(size: 18))
                                
                                Spacer()
                                
                                Text("\(viewModel.timeBonus) PTS")
                                    .padding(.trailing, 10)
                                    .font(.system(size: 18))
                            }// HStack
                            .padding()
                            .background(Color(UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)))
                            
                            HStack {
                                Text("HINTS")
                                    .padding(.leading, 10)
                                    .font(.system(size: 18))
                                
                                Spacer()
                                
                                Text("\(viewModel.hints) PTS")
                                    .padding(.trailing, 10)
                                    .font(.system(size: 18))
                            }// HStack
                            .padding()
                            .background(Color(UIColor(red: 211/255, green: 211/255, blue: 211/255, alpha: 1.0)))
                            .padding(.top, 10)
                            
                            HStack {
                                Text("MISTAKES")
                                    .padding(.leading, 10)
                                    .font(.system(size: 18))
                                
                                Spacer()
                                
                                Text("\(viewModel.mistakes) PTS")
                                    .padding(.trailing, 10)
                                    .font(.system(size: 18))
                            }// HStack
                            .padding()
                            .background(Color(UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)))
                            .padding(.top, 10)
                            
                            HStack {
                                Text("UNDO")
                                    .padding(.leading, 10)
                                    .font(.system(size: 18))
                                
                                Spacer()
                                
                                Text("\(viewModel.undo) PTS")
                                    .padding(.trailing, 10)
                                    .font(.system(size: 18))
                            }// HStack
                            .padding()
                            .background(Color(UIColor(red: 211/255, green: 211/255, blue: 211/255, alpha: 1.0)))
                            .padding(.top, 10)
                            
                            HStack {
                                Text("REDO")
                                    .padding(.leading, 10)
                                    .font(.system(size: 18))
                                
                                Spacer()
                                
                                Text("\(viewModel.redo) PTS")
                                    .padding(.trailing, 10)
                                    .font(.system(size: 18))
                            }// HStack
                            .padding()
                            .background(Color(UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)))
                            .padding(.top, 10)
                            
                            HStack {
                                Text("TIME")
                                    .padding(.leading, 10)
                                    .font(.system(size: 18))
                                
                                Spacer()
                                
                                Text("\(viewModel.time) PTS")
                                    .padding(.trailing, 10)
                                    .font(.system(size: 18))
                            }// HStack
                            .padding()
                            .background(Color(UIColor(red: 211/255, green: 211/255, blue: 211/255, alpha: 1.0)))
                            .padding(.top, 10)
                            
                            HStack {
                                Text("BEST TIME")
                                    .padding(.leading, 10)
                                    .font(.system(size: 18))
                                
                                Spacer()
                                
                                Text("\(viewModel.bestTime) PTS")
                                    .padding(.trailing, 10)
                                    .font(.system(size: 18))
                            }// HStack
                            .padding()
                            .background(Color(UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)))
                            .padding(.top, 10)
                        }// VStack
                        .padding(.top, 5)
                    }// VStack
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.white)
                    .cornerRadius(20)
                    .shadow(radius: 5)
                    .padding(.horizontal, 20)
                    
                    Spacer()
                }// Scroll View
                
                VStack(spacing: 10) {
                    HStack(spacing: 15) {
                        Button(action: {
                            viewModel.newGame()
                        }) {
                            Text("NEW GAME")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.black.opacity(0.7))
                                .cornerRadius(10)
                                .shadow(radius: 5)
                        }

                        Button(action: {
                            viewModel.exit()
                        }) {
                            Text("EXIT")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.black.opacity(0.7))
                                .cornerRadius(10)
                                .shadow(radius: 5)
                        }
                    }// HStack

                    HStack(spacing: 15) {
                        Button(action: {
                            viewModel.streak()
                        }) {
                            Text("🔥 STREAK")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.black.opacity(0.7))
                                .cornerRadius(10)
                                .shadow(radius: 5)
                        }

                        Button(action: {
                            viewModel.share()
                        }) {
                            Image("share")
                                .renderingMode(.template)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 24, height: 24)
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.black.opacity(0.7))
                                .cornerRadius(10)
                                .shadow(radius: 5)
                        }
                        .frame(width: 70)
                    }// HStack
                }// VStack
                .padding(.horizontal, 20)
                .padding(.bottom)
            }// VStack
            NavigationLink(destination: MenuView(), isActive: $viewModel.exitToMainMenu) {
                EmptyView()
            }
            .hidden()
        }// ZStack
        .navigationBarHidden(true)
        .fullScreenCover(isPresented: $viewModel.showStreak) {
            StreakView()
        }
    }
}

// MARK: Preview

#Preview {
    PointsView()
}
