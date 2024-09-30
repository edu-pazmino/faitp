//
//  Item.swift
//  Faitp
//
//  Created by Edu Pazmiño Peralta on 29/9/24.
//

import Foundation
import SwiftData

@Model
final class Item {
    var name: String
    
    init(name: String) {
        self.name = name
    }
}
