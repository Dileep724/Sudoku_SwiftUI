//
//  IndividualScoreBoardViewModel.swift
//  Sudoku_SwiftUI
//
//  Created by Dileep Kumar on 13/10/25.
//

import SwiftUI
import Combine

// MARK: - Individual Score Board View Model

class IndividualScoreBoardViewModel: ObservableObject {
    
    // MARK: - Properties
    
    @Published var leaderboard: individualLeaderBoard?
    @Published var profileImage: UIImage? = UIImage(systemName: "person.circle.fill")
    @Published var name: String = "Dileep Kumar"
    @Published var title1: String = "Category"
    @Published var title2: String = "Best Time"
    @Published var title3: String = "Points"
    
    func fetchScoreCard(riderId: String) {
        let urlString = "\(ApiServices.individualScore)\(riderId)"
        
        NetworkManager.shared.request(
            urlString: urlString,
            method: .GET,
            bodyType: .json,
            responseType: individualLeaderBoard.self
        ) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let leaderboard):
                    self?.leaderboard = leaderboard
                case .failure(let error):
                    print("❌ Error fetching leaderboard: \(error)")
                }
            }
        }
    }
    
    func fetchProfileData(mobileNumber: String = "7288037796") {
        let urlString = ApiServices.profileDetails
        guard let url = URL(string: urlString) else { return }
        
        let bodyString = "mobileNumber=\(mobileNumber)&whichapp=campuslife"
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = bodyString.data(using: .utf8)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
            guard let self = self else { return }
            if let error = error {
                print("❌ Network error: \(error)")
                return
            }
            guard let data = data else { return }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let profileArray = json["profile"] as? [[String: Any]],
                   let profile = profileArray.first {
                    
                    let firstName = profile["firstName"] as? String ?? ""
                    let lastName = profile["lastName"] as? String ?? ""
                    let profileUrl = profile["profileUrl"] as? String ?? ""
                    
                    DispatchQueue.main.async {
                        self.name = "\(firstName) \(lastName)"
                        self.downloadImage(from: profileUrl)
                    }
                }
            } catch {
                print("❌ JSON parsing error: \(error.localizedDescription)")
            }
        }.resume()
    }

    // MARK: - Download Image
    private func downloadImage(from urlString: String) {
        guard let url = URL(string: urlString), !urlString.isEmpty else {
            self.profileImage = UIImage(systemName: "person.circle.fill")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.profileImage = image
                }
            }
        }.resume()
    }
}
