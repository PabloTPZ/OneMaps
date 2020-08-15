//
//  LoginResponse.swift
//  OnTheMaps
//
//  Created by Pablo Perez Zeballos on 8/10/20.
//  Copyright © 2020 Pablo Perez Zeballos. All rights reserved.
//


import Foundation

struct LoginResponse: Codable {
    let account: Account
    let session: Session
}

struct Account: Codable {
    let registered: Bool
    let key: String
}

