//
//  Item.swift
//  RippleView
//
//  Created by Lara Aksoy on 4.12.2025.
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
