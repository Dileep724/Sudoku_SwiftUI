//
//  InstructionCard.swift
//  Sudoku_SwiftUI
//
//  Created by Dileep Kumar on 15/10/25.
//

import SwiftUI

struct InstructionCard: View {
    let item: InstructionItem

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(item.heading)
                .font(.system(size: 25, weight: .bold))
                .foregroundColor(.blue)
            ForEach(item.text, id: \.self) { line in
                Text("• \(line)")
                    .font(.system(size: 20, weight: .regular))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.leading)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.15), radius: 4, x: 0, y: 2)
        .padding(.horizontal, 0)
    }
}
