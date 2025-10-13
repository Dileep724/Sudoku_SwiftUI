//
//  ScoreCardView.swift
//  Sudoku_SwiftUI
//
//  Created by Dileep Kumar on 13/10/25.
//

import SwiftUI

// MARK: - Score Card View

struct ScoreCardView: View {
    
    // MARK: - Properties
    
    let category: String
    let time: String
    let score: String
    
    var body: some View {
        HStack(spacing: 0) {
            Text("⭐ \(category)")
                .font(.headline)
                .foregroundColor(.black)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text(time)
                .font(.headline)
                .foregroundColor(.black)
                .frame(width: 80, alignment: .center)
            
            Text(score)
                .font(.headline)
                .foregroundColor(.black)
                .frame(width: 80, alignment: .trailing)
        }// HStack
        .padding(.horizontal)
        .padding(.vertical, 15)
        .background(Color(UIColor(red: 240/255.0, green: 242/255.0, blue: 245/255.0, alpha: 1.0)))
        .cornerRadius(10)
    }
}

// MARK: - Preview

#Preview {
    ScoreCardView(category: "Expert", time: "8.40", score: "58")
}
