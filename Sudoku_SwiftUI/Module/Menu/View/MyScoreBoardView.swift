//
//  MyScoreBoardView.swift
//  Sudoku_SwiftUI
//
//  Created by Dileep Kumar on 10/10/25.
//

import SwiftUI

// MARK: - My Score Board View

struct MyScoreBoardView: View {
    
    // MARK: - Properties
    
    @ObservedObject var themeManager = ThemeManager.shared
    @StateObject private var viewModel = IndividualScoreBoardViewModel()
    
    // MARK: - View
    
    var body: some View {
        ZStack {
            Image(themeManager.selectedTheme.imageName)
                .resizable()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea()
            
            VStack(spacing: 5) {
                Text("MY SCORE BOARD")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .padding(.top, 50)
                
                VStack(alignment: .leading, spacing: 4) {
                    
                    HStack(spacing: 10) {
                        Image(uiImage: viewModel.profileImage ?? UIImage(systemName: "person.circle.fill")!)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 60, height: 60)
                            .clipShape(Circle())
                            .foregroundColor(.white)
                        
                        Text(viewModel.name)
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                        Spacer()
                        
                    }// HStack
                    .onAppear {
                        viewModel.fetchProfileData()
                    }
                    .padding([.leading, .trailing, .top, .bottom])
                    .background(Color(UIColor(red: 80/255.0, green: 9/255.0, blue: 176/255.0, alpha: 1.0)))
                    .mask(
                        Path { path in
                            let rect = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 32, height: 80)
                            path.move(to: CGPoint(x: rect.minX, y: rect.maxY))
                            path.addLine(to: CGPoint(x: rect.minX, y: rect.minY + 10))
                            path.addQuadCurve(to: CGPoint(x: rect.minX + 10, y: rect.minY), control: CGPoint(x: rect.minX, y: rect.minY))
                            path.addLine(to: CGPoint(x: rect.maxX - 10, y: rect.minY))
                            path.addQuadCurve(to: CGPoint(x: rect.maxX, y: rect.minY + 10), control: CGPoint(x: rect.maxX, y: rect.minY))
                            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
                            path.closeSubpath()
                        }
                    )
                    
                    HStack(spacing: 0) {
                        Text(viewModel.title1)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Text(viewModel.title2)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .frame(width: 80, alignment: .center)
                        
                        Text(viewModel.title3)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .frame(width: 80, alignment: .trailing)
                    }
                    .padding(.horizontal)
                    .padding(.top, 8)
                    
                    Divider()
                        .background(Color.black)
                        .frame(height: 10)
                    
                    VStack() {
                        if let stats = viewModel.leaderboard?.category_stats{
                            ForEach(stats, id: \.category) { stat in
                                ScoreCardView(
                                    category: stat.category.capitalized,
                                    time: "\(stat.best_time) sec",
                                    score: "\(stat.total_points)"
                                )
                                
                            }
                            if let total = viewModel.leaderboard?.grand_total_points {
                                HStack {
                                    Spacer()
                                    HStack(spacing: 4) {
                                        Image(systemName: "crown.fill")
                                            .foregroundColor(.yellow)
                                        
                                        Text("Total Points:")
                                            .font(.headline)
                                            .foregroundColor(.black)
                                        
                                        Text("\(total)")
                                            .font(.headline)
                                            .fontWeight(.bold)
                                            .foregroundColor(Color(UIColor(red: 80/255.0, green: 9/255.0, blue: 176/255.0, alpha: 1.0)))
                                    }
                                    Spacer()
                                }
                                .padding()
                                .frame(alignment: .center)
                                .background(Color(UIColor(red: 240/255, green: 242/255, blue: 245/255, alpha: 1)))
                                .cornerRadius(10)
                            }
                        } else {
                            Text("No Data Found...")
                        }
                    }// VStack
                    .onAppear {
                        viewModel.fetchScoreCard(riderId: "2")
                    }
                    .padding()
                    
                }// VStack
                .padding(.bottom, 10)
                .background(Color.white)
                .cornerRadius(15)
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                .padding()
                
                Spacer()
            }// VStack
        }// ZStack
    }
}

// MARK: - Preview

#Preview {
    MyScoreBoardView()
}
