//
//  SplashScreenModel.swift
//  Sudoku_SwiftUI
//
//  Created by Dileep Kumar on 10/10/25.
//

import Combine
import SwiftUI

// MARK: - Splash Screen Model

class SplashScreenModel: ObservableObject {
    
    //MARK: - Properties
    
    @Published var progress: Double = 0.0
    @Published var navigateToMenu: Bool = false
    
    // MARK: - Progress Animation
    
    func startProgressAnimation() {
        _ = Timer.scheduledTimer(withTimeInterval: 0.02, repeats: true) { timer in
            if self.progress < 1.0 {
                self.progress += 0.02
            } else {
                timer.invalidate()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.navigateToMenu = true
                }
            }
        }
    }
}
