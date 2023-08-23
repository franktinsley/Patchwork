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
    @Query private var nodes: [Node]
    @State private var showingAddNodeDialog = false

    var body: some View {
        NavigationStack {
            ScrollView([.horizontal, .vertical]) {
                ForEach(nodes) { node in
                    if node.parent == nil {
                        NodeView(node: node)
                    }
                }
                .onDelete(perform: deleteNodes)
            }
            .defaultScrollAnchor(.top)
            .toolbar {
                ToolbarItem {
                    Button(action: { showingAddNodeDialog = true }) {
                        Label("Add Node", systemImage: "plus")
                    }
                }
            }
        }
        .confirmationDialog(
            "Add Node",
            isPresented: $showingAddNodeDialog
        ) {
            ForEach(Value.allCases) { value in
                Button(value.name) {
                    addNode(node: Node.of(type: .intermediate, for: value, inside: nil))
                }
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Choose node to add")
        }
    }

    private func addNode(node: Node) {
        modelContext.insert(node)
    }

    private func deleteNodes(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(nodes[index])
        }
    }
}

#Preview {
    ContentView()
//        .modelContainer(PreviewSampleData.container)
        .modelContainer(for: Node.self, inMemory: true)
}
