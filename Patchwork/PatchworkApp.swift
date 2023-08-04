import SwiftData
import SwiftUI
import UniformTypeIdentifiers

@main
struct PatchworkApp: App {
    var body: some Scene {
        DocumentGroup(editing: Module.self, contentType: .itemDocument) {
            ContentView()
        }
    }
}

extension UTType {
    static var itemDocument: UTType {
        UTType(importedAs: "com.example.item-document")
    }
}
