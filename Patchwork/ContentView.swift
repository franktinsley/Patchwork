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
        let system = System(nodes: [], connections: [])
        modelContext.insert(system)
        
        let intLiteralA = Node(outputs: [Port(value: .int(2))])
        let intLiteralB = Node(outputs: [Port(value: .int(3))])
        let addInts = Node(
            inputs: [
                Port(name: "lhs", value: .int(0)),
                Port(name: "rhs", value: .int(0))
            ],
            outputs: [
                Port(name: "Output", value: .int(0))
            ]
        )
        
        system.nodes.append(contentsOf: [intLiteralA, intLiteralB, addInts])
        
        let connectionA = Connection(from: intLiteralA.outputs[0], to: addInts.inputs[0])
        let connectionB = Connection(from: intLiteralB.outputs[0], to: addInts.inputs[1])
        
        
        system.connections.append(contentsOf: [
            connectionA, connectionB
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
