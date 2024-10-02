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
    var path: String
    var url: URL
    
    init(name: String, path: String, url: URL) {
        self.name = name
        self.path = path
        self.url = url
    }
}
