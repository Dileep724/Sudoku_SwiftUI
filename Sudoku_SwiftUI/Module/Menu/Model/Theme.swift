//
//  Theme.swift
//  Sudoku_SwiftUI
//
//  Created by Dileep Kumar on 13/10/25.
//

import Foundation
import SwiftUI

struct Theme: Identifiable, Equatable {
    let id: Int  
    let name: String
    let image: Image?
}

struct ThemeResponse: Decodable {
    let success: Bool
    let themes: [ThemeAPI]
    let grids: [GridAPI]
}

struct ThemeAPI: Identifiable, Decodable {
    let theme_id: Int
    let image: String
    let status: Bool
    let theme_name: String
    
    var id: Int { theme_id }
}
