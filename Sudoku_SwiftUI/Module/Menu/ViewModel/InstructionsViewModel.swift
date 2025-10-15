//
//  InstructionsViewModel.swift
//  Sudoku_SwiftUI
//
//  Created by Dileep Kumar on 15/10/25.
//

import SwiftUI
import Combine

// MARK: - Instructions View Model

class InstructionsViewModel: ObservableObject {
    
    // MARK: - Properties
    
    @Published var title: String = ""
    @Published var instructions: [InstructionItem] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - API Call To Fetch Instructions
    
    func fetchInstructions() {
        isLoading = true
        errorMessage = nil
        
        NetworkManager.shared.request(
            urlString: ApiServices.getInstructions,
            method: .POST,
            parameters: nil,
            bodyType: .json,
            headers: nil,
            responseType: [InstructionResponse].self
        ) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let responseArray):
                    if let first = responseArray.first {
                        self?.title = first.title
                        self?.instructions = first.instructions
                    }
                case .failure(let error):
                    self?.errorMessage = "Failed to load instructions: \(error.localizedDescription)"
                }
            }
        }
    }
}
