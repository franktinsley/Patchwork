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
    @State private var showingAddModuleDialog = false

    var body: some View {
        NavigationStack {
            ZStack {
                ForEach(modules) { module in
                    if module.parent == nil {
                        ModuleView(module: module)
                    }
                }
                .onDelete(perform: deleteModules)
            }
            .toolbar {
                ToolbarItem {
                    Button(action: { showingAddModuleDialog = true }) {
                        Label("Add Module", systemImage: "plus")
                    }
                }
            }
        }
        .confirmationDialog(
            "Add Module",
            isPresented: $showingAddModuleDialog
        ) {
            ForEach(Value.allCases) { value in
                Button(value.name) { addModule(module: Module.module(for: value, parent: nil)) }
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Choose module to add")
        }
    }

    private func addModule(module: Module) {
        modelContext.insert(module)
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
