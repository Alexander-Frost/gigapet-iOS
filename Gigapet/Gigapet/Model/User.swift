//
//  User.swift
//  Gigapet
//
//  Created by Alex on 5/21/19.
//  Copyright © 2019 Alex. All rights reserved.
//

import Foundation

struct User: Codable {
    let name: String
    let password: String
    let email: String?
}
