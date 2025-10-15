//
//  Instructions.swift
//  Sudoku_SwiftUI
//
//  Created by Dileep Kumar on 15/10/25.
//

import Foundation

struct InstructionResponse: Codable, Identifiable {
    let id: Int
    let title: String
    let instructions: [InstructionItem]
    let status: Bool
    let created_at: String
    let updated_at: String
}

struct InstructionItem: Codable, Identifiable {
    var id: String { heading }
    let heading: String
    let text: [String]
}
