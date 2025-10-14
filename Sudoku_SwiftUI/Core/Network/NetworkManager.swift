//
//  NetworkManager.swift
//  Sudoku_SwiftUI
//
//  Created by Dileep Kumar on 13/10/25.
//

import Foundation
import Network

// MARK: - Network Manager Class
final class NetworkManager {
    static let shared = NetworkManager()
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitor")
    private var isConnected: Bool = true
    
    private init() {
        monitor.pathUpdateHandler = { [weak self] path in
            self?.isConnected = (path.status == .satisfied)
        }
        monitor.start(queue: queue)
    }
    
    // MARK: - Public Method
    func request<T: Decodable>(urlString: String, method: HTTPMethod, parameters: [String: Any]? = nil, bodyType: BodyType,  headers: [String: String]? = nil, responseType: T.Type, completion: @escaping (Result<T, NetworkError>) -> Void ) {
        // Check Internet Connection
        guard isConnected else {
            completion(.failure(.noInternet))
            return
        }
        
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        // Add Headers
        headers?.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        // Add Body
        switch bodyType {
        case .formURLEncoded:
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            if let params = parameters as? [String: String] {
                let bodyString = params
                    .map { "\($0.key)=\(percentEscape($0.value))" }
                    .joined(separator: "&")
                
                request.httpBody = bodyString.data(using: .utf8)
            } else {
                completion(.failure(.invalidParameters))
                return
            }
            
        case .json:
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            if let parameters = parameters {
                request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: [])
            }
            
        case .multipart(let boundary, let media):
            let finalBoundary = boundary ?? "Boundary-\(UUID().uuidString)"
            request.setValue("multipart/form-data; boundary=\(finalBoundary)", forHTTPHeaderField: "Content-Type")
            request.httpBody = createMultipartBody(parameters: parameters, media: media, boundary: finalBoundary)
        }
        
        // Network Call
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            // Network Level Error
            if let error = error as NSError?, error.domain == NSURLErrorDomain {
                if error.code == NSURLErrorNotConnectedToInternet {
                    completion(.failure(.noInternet))
                } else if error.code == NSURLErrorTimedOut {
                    completion(.failure(.timeout))
                } else {
                    completion(.failure(.networkError(error)))
                }
                return
            }
            
            // HTTP Response Validation
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(.httpError(code: httpResponse.statusCode, message: HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode))))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            // Decode JSON
            do {
                let decoded = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decoded))
            } catch {
                if let rawString = String(data: data, encoding: .utf8) {
                    print("🔍 Raw Response: \(rawString)")
                }
                completion(.failure(.decodingFailed(error)))
            }
        }
        
        task.resume()
    }
    
    // MARK: - Multipart Helper
    private func createMultipartBody(parameters: [String: Any]?, media: [Media]?, boundary: String) -> Data {
        var body = Data()
        let lineBreak = "\r\n"
        
        // Parameters
        parameters?.forEach { key, value in
            body.append("--\(boundary)\(lineBreak)")
            body.append("Content-Disposition: form-data; name=\"\(key)\"\(lineBreak + lineBreak)")
            body.append("\(value)\(lineBreak)")
        }
        
        // Media Files
        media?.forEach { media in
            body.append("--\(boundary)\(lineBreak)")
            body.append("Content-Disposition: form-data; name=\"\(media.key)\"; filename=\"\(media.filename)\"\(lineBreak)")
            body.append("Content-Type: \(media.mimeType)\(lineBreak + lineBreak)")
            body.append(media.data)
            body.append(lineBreak)
        }
        
        body.append("--\(boundary)--\(lineBreak)")
        return body
    }
    
    // MARK: - Percent Escape
    private func percentEscape(_ string: String) -> String {
        let allowed = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-._* ")
        return string.addingPercentEncoding(withAllowedCharacters: allowed)?.replacingOccurrences(of: " ", with: "+") ?? string
    }
}


// MARK: - Media Struct
struct Media {
    let key: String
    let filename: String
    let data: Data
    let mimeType: String
}

extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            self.append(data)
        }
    }
}
