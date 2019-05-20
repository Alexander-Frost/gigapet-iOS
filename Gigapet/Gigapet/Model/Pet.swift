//
//  Pet.swift
//  Gigapet
//
//  Created by Alex on 5/20/19.
//  Copyright © 2019 Alex. All rights reserved.
//

import Foundation

class Pet {
    static let shared = Pet()
    private init() {}
    
    var shouldRoll = false
    var shouldZoom = false
}
