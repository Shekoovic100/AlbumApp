//
//  AlbumViewModel.swift
//  AlbumsApp
//
//  Created by ITSP on 20/11/2024.
//

import Foundation
import Combine


class AlbumViewModel {
    
    
    @Published var users: [Users] = []
    @Published var albums: [Albums] = []
    @Published var albumImages: [AlbumImages] = []
    @Published var errorMessage: String? 
    
    private var cancellables: Set<AnyCancellable> = []
    private let service: APIServiceProtocol

    
    init(service: APIServiceProtocol = APIService()) {
        self.service = service
    }
    
    
    func fetchUsers() {
        service.fetchData(endpoint: URLEndpoints.getUsers)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }, receiveValue: {(users: [Users]) in
                let randomUser = users.randomElement() ?? users[0]
                print(randomUser)
                self.users = [randomUser]
                self.fetchAlbums()
            })
            .store(in: &cancellables)
    }
    
    
    func fetchAlbums() {
        
        let randomUserId = users.randomElement()?.id ?? 1
        service.fetchData(endpoint: URLEndpoints.getAlbumsForUsers(id: randomUserId))
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("Finished successfully")
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }, receiveValue: { (albums: [Albums]) in
                print("Albums: \(albums)")
                self.albums = albums
                self.fetchImages(albumId: albums[0].id)
            })
            .store(in: &cancellables)
    }
    
    func fetchImages(albumId: Int) {
        service.fetchData(endpoint: URLEndpoints.getImages(albumId: albumId))
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("Finished successfully")
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }, receiveValue: { (Images: [AlbumImages]) in
                print("Album Images: \(Images)")
                self.albumImages = Images
            })
            .store(in: &cancellables)
    }
    
}
