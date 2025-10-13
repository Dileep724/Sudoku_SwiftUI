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
        HStack(alignment: .center) {
//            Spacer()
            Text("⭐ \(category)")
                .font(.headline)
                .foregroundColor(.black)
            Spacer()
            Text(time)
                .font(.headline)
                .foregroundColor(.black)
            Spacer()
            Text(score)
                .font(.headline)
                .foregroundColor(.black)
//            Spacer()
        }// HStack
        .padding()
        .background(Color(UIColor(red: 240/255.0, green: 242/255.0, blue: 245/255.0, alpha: 1.0)))
        .cornerRadius(10)
    }
}

// MARK: - Preview

#Preview {
    ScoreCardView(category: "Expert", time: "8.40", score: "58")
}
