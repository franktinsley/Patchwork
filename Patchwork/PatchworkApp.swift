//
//  PatchworkApp.swift
//  Patchwork
//
//  Created by Frank Tinsley on 8/2/23.
//

import SwiftUI
import SwiftData
import UniformTypeIdentifiers

@main
struct PatchworkApp: App {
    let schema = Schema([
    	Item.self,
    ])

    var body: some Scene {
        DocumentGroup(editing: schema, contentType: .itemDocument) {
            ContentView()
        }
    }
}

extension UTType {
    static var itemDocument: UTType {
        UTType(importedAs: "com.example.item-document")
    }
}
