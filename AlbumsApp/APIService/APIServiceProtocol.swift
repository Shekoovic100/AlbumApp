//
//  APIServiceProtocol.swift
//  AlbumsApp
//
//  Created by ITSP on 20/11/2024.
//

import Foundation
import Combine

protocol APIServiceProtocol {
    func fetchData<T: Decodable>(endpoint: String) -> AnyPublisher<T, Error>
}
