//
//  Item.swift
//  NewYear
//
//  Created by BARAN DALBUDAK on 23.12.2024.
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
