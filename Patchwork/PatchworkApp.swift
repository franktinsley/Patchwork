import SwiftData
import SwiftUI
import UniformTypeIdentifiers

@main
struct PatchworkApp: App {
    let schema = Schema([
        System.self
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
