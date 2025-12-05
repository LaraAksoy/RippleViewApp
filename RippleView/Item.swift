
//
//  Item.swift
//  Landmark Story
//
//  Created by Lara Aksoy on 5.12.2025.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
