import SwiftUI

struct ModuleView: View {
    @Bindable var module: Module
    var body: some View {
        NavigationLink {
            List {
                if module.children.isEmpty {
                    Text("No children")
                } else {
                    ForEach(module.children) { child in
                        ModuleView(module: child)
                    }
                }
            }
        } label: {
            Text(module.metal)
                .badge(module.children.count)
        }
    }
}

// #Preview {
//    ModuleView()
//        .modelContainer(for: Module.self, inMemory: true)
// }
