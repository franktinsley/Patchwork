import SwiftUI

struct ModuleView: View {
    @Bindable var module: Module
    @State private var showingAddModuleDialog = false
    private let gridStep = CGFloat(25)

    var body: some View {
        VStack {
            NavigationLink {
                ZStack {
                    ForEach(module.children) { child in
                        ModuleView(module: child)
                    }
                }
                .navigationTitle(module.name ?? "Module")
                .toolbar {
                    ToolbarItem {
                        Button(action: { showingAddModuleDialog = true }) {
                            Label("Add Module", systemImage: "plus")
                        }
                    }
                }
            } label: {
                Text(module.metal)
                    .badge(module.children.count)
            }
        }
        .frame(width: gridStep * 4, height: gridStep * 4)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: gridStep))
        .position(
            CGPoint(
                x: round(module.positionX / gridStep) * gridStep,
                y: round(module.positionY / gridStep) * gridStep
            )
        )
        .highPriorityGesture(
            DragGesture()
                .onChanged { gesture in
                    withAnimation(.interactiveSpring) {
                        module.positionX = gesture.location.x
                        module.positionY = gesture.location.y
                    }
                }
        )
        .confirmationDialog(
            "Add Module",
            isPresented: $showingAddModuleDialog
        ) {
            ForEach(Value.allCases) { value in
                Button(value.name) { addModule(module: Module.module(for: value, parent: module)) }
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Choose module to add")
        }
    }

    private func addModule(module: Module) {
        self.module.children.append(module)
    }
}

// #Preview {
//     ModuleView(module: .preview)
//         .modelContainer(PreviewSampleData.container)
// }
