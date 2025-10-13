//
//  ApiStruct.swift
//  Sudoku_SwiftUI
//
//  Created by Dileep Kumar on 13/10/25.
//

import Foundation

struct individualLeaderBoard: Codable {
    let rider_id: String
    let category: String
    let category_stats: [Category_Status]
    let grand_total_points: Int
    let detail: String?
}

struct Category_Status: Codable {
    let category: String
    let best_time: Int
    let total_points: Int
}
