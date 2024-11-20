//
//  APIService.swift
//  AlbumsApp
//
//  Created by ITSP on 20/11/2024.
//

import Foundation
import Combine



class APIService: APIServiceProtocol {
    
    func fetchData<T: Decodable>(endpoint: String) -> AnyPublisher<T, Error> {
        guard let url = URL(string: endpoint) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: T.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
}
