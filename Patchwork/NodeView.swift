import SwiftUI

struct NodeView: View {
    @Bindable var node: Node
    @State private var showingAddNodeDialog = false
    private let gridStep = CGFloat(100)

    var body: some View {
        VStack {
            NavigationLink {
                ZStack {
                    ForEach(node.children) { child in
                        NodeView(node: child)
                    }
                }
                .navigationTitle(node.name ?? "Node")
                .toolbar {
                    ToolbarItem {
                        Button(action: { showingAddNodeDialog = true }) {
                            Label("Add Node", systemImage: "plus")
                        }
                    }
                }
            } label: {
                Text(node.name ?? "Node")
                    .padding()
                    .badge(node.children.count)
            }
        }
//        .frame(width: gridStep - (gridStep / 8), height: gridStep / 2 - (gridStep / 8))
        .frame(width: 100, height: 100)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: gridStep / 4))
        .position(
            CGPoint(
                x: node.x,
                y: node.y
//                x: min(max(round(node.positionX / gridStep) * gridStep, 0), gridStep * 5),
//                y: min(max(round(node.positionY / 50) * 50, 0), gridStep * 7)
            )
        )
        .highPriorityGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { gesture in
                    withAnimation(.interactiveSpring) {
                        node.x = gesture.location.x
                        node.y = gesture.location.y
                    }
                }
        )
        .confirmationDialog(
            "Add Node",
            isPresented: $showingAddNodeDialog
        ) {
            ForEach(Value.allCases) { value in
                Button(value.name) {
                    addNode(node: Node.of(type: .intermediate, for: value, inside: node))
                }
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Choose node to add")
        }
    }

    private func addNode(node: Node) {
        self.node.children.append(node)
    }
}

// #Preview {
//     NodeView(node: .preview)
//         .modelContainer(PreviewSampleData.container)
// }
