import SwiftData
import SwiftUI
import UniformTypeIdentifiers

@main
struct PatchworkApp: App {
    var body: some Scene {
//        DocumentGroup(editing: [Node.self], contentType: .itemDocument) {
//            ContentView()
//        }
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Node.self)
    }
}

extension UTType {
    static var itemDocument: UTType {
        UTType(importedAs: "com.example.item-document")
    }
}
