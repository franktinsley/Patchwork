//
//  Item.swift
//  Patchwork
//
//  Created by Frank Tinsley on 8/2/23.
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
