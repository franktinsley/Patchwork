//
//  ContentView.swift
//  Patchwork
//
//  Created by Frank Tinsley on 8/2/23.
//

import SwiftData
import SwiftUI

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var modules: [Module]

    var body: some View {
        NavigationStack {
            List {
                if modules.isEmpty {
                    Text("No modules")
                } else {
                    ForEach(modules) { module in
                        if module.parent == nil {
                            ModuleView(module: module)
                        }
                    }
                    .onDelete(perform: deleteModules)
                }
            }
            .toolbar {
                ToolbarItem {
                    Button(action: addModule) {
                        Label("Add Module", systemImage: "plus")
                    }
                }
            }
        }
    }

    private func addModule() {
        let module = Module(outputs: [])
        modelContext.insert(module)

        let intLiteralA = Module(outputs: [.init(value: .int(2))], parent: module)
        let intLiteralB = Module(outputs: [.init(value: .int(3))], parent: module)
        let addInts = Module(
            inputs: [
                .init(name: "lhs", value: .int(0)),
                .init(name: "rhs", value: .int(0))
            ],
            outputs: [
                .init(name: "Output", value: .int(0))
            ],
            parent: module
        )

        module.children.append(contentsOf: [intLiteralA, intLiteralB, addInts])
        module.connections.append(contentsOf: [
            .init(from: intLiteralA.outputs[0], to: addInts.inputs[0]),
            .init(from: intLiteralB.outputs[0], to: addInts.inputs[1])
        ])
    }

    private func deleteModules(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(modules[index])
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(PreviewSampleData.container)
}
