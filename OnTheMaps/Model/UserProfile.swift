//
//  UserProfile.swift
//  OnTheMaps
//
//  Created by Pablo Perez Zeballos on 8/10/20.
//  Copyright © 2020 Pablo Perez Zeballos. All rights reserved.
//
import Foundation

struct UserProfile: Codable {
    let firstName: String
    let lastName: String
    let nickname: String
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case nickname
    }
 
}
