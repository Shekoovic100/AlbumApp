//
//  URLData.swift
//  AlbumsApp
//
//  Created by ITSP on 20/11/2024.
//

import Foundation


class URLEndpoints {
    
    static var baseURL =  "https://jsonplaceholder.typicode.com"
    static var getUsers = baseURL  + "/users"
    static func getAlbumsForUsers(id: Int) -> String {
        return  baseURL + "/albums?userId=\(id)"
    }
    static func getImages(albumId: Int) -> String {
        return  baseURL + "/photos?albumId=\(albumId)"
    }
}
