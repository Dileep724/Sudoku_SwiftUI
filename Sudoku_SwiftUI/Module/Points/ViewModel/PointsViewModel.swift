//
//  PointsViewModel.swift
//  Sudoku_SwiftUI
//
//  Created by Dileep Kumar on 15/10/25.
//

import SwiftUI
import Combine

// MARK: - Points View Model

class PointsViewModel: ObservableObject {
    
    // MARK: - Properties
    
    @Published var rotateStar = false
    @Published var gamePoints: Int = 50
    @Published var totalPoints: Int = 0
    @Published var difficultyLevel: String = "Easy"
    @Published var timeBonus: Int = 10
    @Published var hints: Int = 10
    @Published var mistakes: Int = 10
    @Published var undo: Int = 10
    @Published var redo: Int = 10
    @Published var time: Int = 10
    @Published var bestTime: Int = 10
    @Published var exitToMainMenu: Bool = false
    @Published var showStreak: Bool = false
    
    func newGame() {
        
    }
    
    func exit() {
        exitToMainMenu = true
    }
    
    func streak() {
        showStreak = true
    }
    
    func share() {
        guard let baseImage = UIImage(named: "app") else { return }
        guard let winnerImage = UIImage(named: "winner") else { return }

        let imageWidth = baseImage.size.width
        let titleFont = UIFont.boldSystemFont(ofSize: imageWidth / 10)
        let congratsFont = UIFont.boldSystemFont(ofSize: imageWidth / 12)
        let subtitleFont = UIFont.systemFont(ofSize: imageWidth / 18)
        let labelFont = UIFont.boldSystemFont(ofSize: imageWidth / 18)
        
        let winnerSize = imageWidth / 3
        let verticalPadding: CGFloat = 20
        
        var totalHeight = verticalPadding +
            titleFont.lineHeight + 20 +
            winnerSize + 20 +
            congratsFont.lineHeight + 10 +
            subtitleFont.lineHeight + 20 +
            3 * (labelFont.lineHeight + 10) +
            verticalPadding
     
        totalHeight += 100

        let renderer = UIGraphicsImageRenderer(size: CGSize(width: imageWidth, height: totalHeight))
        let imageWithText = renderer.image { _ in
            var currentY: CGFloat = verticalPadding

            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center

            let shadow = NSShadow()
            shadow.shadowColor = UIColor.black.withAlphaComponent(0.5)
            shadow.shadowOffset = CGSize(width: 2, height: 2)
            shadow.shadowBlurRadius = 3

            let titleAttributes: [NSAttributedString.Key: Any] = [
                .font: titleFont, .foregroundColor: UIColor.white,
                .paragraphStyle: paragraphStyle, .shadow: shadow
            ]
            let congratsAttributes: [NSAttributedString.Key: Any] = [
                .font: congratsFont, .foregroundColor: UIColor.white,
                .paragraphStyle: paragraphStyle, .shadow: shadow
            ]
            let subtitleAttributes: [NSAttributedString.Key: Any] = [
                .font: subtitleFont, .foregroundColor: UIColor.white,
                .paragraphStyle: paragraphStyle
            ]
            let labelAttributes: [NSAttributedString.Key: Any] = [
                .font: labelFont, .foregroundColor: UIColor.white,
                .paragraphStyle: paragraphStyle
            ]
            let valueAttributes: [NSAttributedString.Key: Any] = [
                .font: labelFont, .foregroundColor: UIColor.white,
                .paragraphStyle: paragraphStyle
            ]

            baseImage.draw(in: CGRect(x: 0, y: 0, width: imageWidth, height: totalHeight))

            "SUDOKU".draw(in: CGRect(x: 0, y: currentY, width: imageWidth, height: titleFont.lineHeight + 5), withAttributes: titleAttributes)
            currentY += titleFont.lineHeight + 20

            winnerImage.draw(in: CGRect(x: (imageWidth - winnerSize)/2, y: currentY, width: winnerSize, height: winnerSize))
            currentY += winnerSize + 20

            "Congratulations!".draw(in: CGRect(x: 0, y: currentY, width: imageWidth, height: congratsFont.lineHeight + 5), withAttributes: congratsAttributes)
            currentY += congratsFont.lineHeight + 10

            "You solved this puzzle".draw(in: CGRect(x: 0, y: currentY, width: imageWidth, height: subtitleFont.lineHeight + 5), withAttributes: subtitleAttributes)
            currentY += subtitleFont.lineHeight + 20

            "Level: \(difficultyLevel)".draw(in: CGRect(x: 20, y: currentY, width: imageWidth - 40, height: labelFont.lineHeight + 5), withAttributes: labelAttributes)
            currentY += labelFont.lineHeight + 10

            "Score: \(gamePoints) PTS".draw(in: CGRect(x: 20, y: currentY, width: imageWidth - 40, height: labelFont.lineHeight + 5), withAttributes: valueAttributes)
            currentY += labelFont.lineHeight + 10

            "Time Taken: \(time) sec".draw(in: CGRect(x: 20, y: currentY, width: imageWidth - 40, height: labelFont.lineHeight + 5), withAttributes: valueAttributes)
        }

        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootVC = windowScene.windows.first?.rootViewController else { return }

        let activityVC = UIActivityViewController(activityItems: [imageWithText], applicationActivities: nil)
        if let popover = activityVC.popoverPresentationController {
            popover.sourceView = rootVC.view
            popover.sourceRect = CGRect(x: rootVC.view.bounds.midX, y: rootVC.view.bounds.midY, width: 0, height: 0)
            popover.permittedArrowDirections = []
        }
        rootVC.present(activityVC, animated: true)
    }
}
