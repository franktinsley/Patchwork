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
    @Query private var systems: [System]

    var body: some View {
        NavigationSplitView {
            List {
                ForEach(systems) { system in
                    NavigationLink {
                        Text(system.metal)
                    } label: {
                        Text(system.metal)
                    }
                }
                .onDelete(perform: deleteSystems)
            }
            .toolbar {
                ToolbarItem {
                    Button(action: addSystem) {
                        Label("Add System", systemImage: "plus")
                    }
                }
            }
        } detail: {
            Text("Detail View")
        }
    }

    private func addSystem() {
        let system = System(modules: [], connections: [])
        modelContext.insert(system)

        let intLiteralA = Module(outputs: [.init(value: .int(2))])
        let intLiteralB = Module(outputs: [.init(value: .int(3))])
        let addInts = Module(
            inputs: [
                .init(name: "lhs", value: .int(0)),
                .init(name: "rhs", value: .int(0))
            ],
            outputs: [
                .init(name: "Output", value: .int(0))
            ]
        )

        system.modules.append(contentsOf: [intLiteralA, intLiteralB, addInts])
        system.connections.append(contentsOf: [
            .init(from: intLiteralA.outputs[0], to: addInts.inputs[0]),
            .init(from: intLiteralB.outputs[0], to: addInts.inputs[1])
        ])
    }

    private func deleteSystems(offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(systems[index])
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: System.self, inMemory: true)
}
