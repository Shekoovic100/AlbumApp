//
//  Users.swift
//  AlbumsApp
//
//  Created by ITSP on 20/11/2024.
//

import Foundation


struct Users: Codable {
    
    let id: Int
    let name: String
    let username: String
    let website: String
    let address: Address
  
    
}

extension Users {
    var fullAddress: String {
        let result = "\(address.city)," + "\(address.suite)," + "\(address.city)," + address.zipcode
        return result
    }
}

struct Address: Codable {
    
    let street: String
    let suite: String
    let city: String
    let zipcode: String

}
