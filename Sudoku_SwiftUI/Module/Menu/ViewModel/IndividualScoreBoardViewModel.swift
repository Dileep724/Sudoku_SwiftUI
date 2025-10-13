//
//  IndividualScoreBoardViewModel.swift
//  Sudoku_SwiftUI
//
//  Created by Dileep Kumar on 13/10/25.
//

import SwiftUI
import Combine

class IndividualScoreBoardViewModel: ObservableObject {

    @Published var leaderboard: individualLeaderBoard?
    @Published var name: String = "Dileep Kumar"
    @Published var title1: String = "Category"
    @Published var title2: String = "Best Time"
    @Published var title3: String = "Points"

    func fetchScoreCard(riderId: String) {
        guard let url = URL(string: "https://zdotapps.in/carelon/results/?rider_id=\(riderId)") else { return }
        
        Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                let decoded = try JSONDecoder().decode(individualLeaderBoard.self, from: data)
                leaderboard = decoded
            } catch {
                print("Error fetching leaderboard: \(error)")
            }
        }
    }
}
