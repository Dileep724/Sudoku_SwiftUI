//
//  ThemesViewModel.swift
//  Sudoku_SwiftUI
//
//  Created by Dileep Kumar on 11/10/25.
//

import SwiftUI
import Combine

class ThemesViewModel: ObservableObject {
    
    // MARK: - Properties
    
    @Published var isThemesViewVisible = true
    @Published var themes: [Theme] = []
    @Published var gridOptions: [GridOption] = []
    @Published var cancellables = Set<AnyCancellable>()
    
    init() {
        fetchThemesAndGrids()
    }
    
    // MARK: - API Call To Fetch Themes
    
    func fetchThemesAndGrids() {
        NetworkManager.shared.request(
            urlString: ApiServices.getThemes,
            method: .GET,
            bodyType: .json,
            responseType: ThemeResponse.self
        ) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let response):
                var mappedThemes: [Theme] = []

                let group = DispatchGroup()
                for themeAPI in response.themes {
                    group.enter()
                    self.loadImageAsync(from: self.fullImagePath(path: themeAPI.image)) { image in
                        let theme = Theme(id: themeAPI.theme_id, name: themeAPI.theme_name, image: image)
                        mappedThemes.append(theme)
                        group.leave()
                    }
                }

                var mappedGrids: [GridOption] = []
                for gridAPI in response.grids {
                    group.enter()
                    self.loadImageAsync(from: self.fullImagePath(path: gridAPI.grid_image)) { image in
                        let gridOption = GridOption(image: image, color: Color(hex: gridAPI.grid_color) ?? .gray)
                        mappedGrids.append(gridOption)
                        group.leave()
                    }
                }

                group.notify(queue: .main) {
                    self.themes = mappedThemes.sorted { $0.id < $1.id }
                    self.gridOptions = mappedGrids.sorted { $0.color.description > $1.color.description }

                    if ThemeManager.shared.selectedTheme == nil,
                       let firstThemeAPI = response.themes.first(where: { $0.status == true }),
                       let defaultTheme = self.themes.first(where: { $0.id == firstThemeAPI.theme_id }) {
                        withAnimation(.easeInOut) {
                            ThemeManager.shared.selectedTheme = defaultTheme
                        }
                    }

                    if let firstGridAPI = response.grids.first(where: { $0.status == true }) {
                        ThemeManager.shared.selectedGridColor = Color(hex: firstGridAPI.grid_color) ?? .gray
                    }
                }

            case .failure(let error):
                print("Error fetching themes and grids: \(error)")
            }
        }
    }
    
    private func loadImageAsync(from urlString: String, completion: @escaping (Image?) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let data = data, let uiImage = UIImage(data: data) {
                completion(Image(uiImage: uiImage))
            } else {
                completion(nil)
            }
        }.resume()
    }
    
    private func fullImagePath(path: String) -> String {
        
        let baseURL = ApiServices.baseUrl
        let baseURLWithSlash = baseURL.hasSuffix("/") ? baseURL : baseURL + "/"
        let cleanPath = path.hasPrefix("/") ? String(path.dropFirst()) : path
        
        return baseURLWithSlash + cleanPath
    }
    
    func selectTheme(_ theme: Theme) {
        ThemeManager.shared.selectedTheme = theme
    }
    
    func selectGridOption(_ option: GridOption) {
        ThemeManager.shared.selectedGridColor = option.color
    }
    
    func closeThemesView() {
        isThemesViewVisible = false
    }
}

extension URLSession {
    func synchronousDataTask(with url: URL) throws -> (Data, URLResponse) {
        var result: (Data?, URLResponse?, Error?) = (nil, nil, nil)
        let semaphore = DispatchSemaphore(value: 0)
        
        let dataTask = dataTask(with: url) { data, response, error in
            result = (data, response, error)
            semaphore.signal()
        }
        dataTask.resume()
        
        _ = semaphore.wait(timeout: .distantFuture)
        
        if let error = result.2 {
            throw error
        }
        
        return (result.0!, result.1!)
    }
}
