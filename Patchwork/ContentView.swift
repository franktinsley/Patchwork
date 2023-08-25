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
    @Query(sort: \Node.order, order: .forward) var nodes: [Node]
    @State private var selectedNode: Node?
    @State private var contentOffset: CGPoint = .init(x: 0, y: 0)
    @State private var zoomScale: CGFloat = 1
    let canvasSize = CGSize(width: 20000, height: 20000)
    let canvasMinimumZoomScale = 0.1

    var body: some View {
        GeometryReader { geometry in
            NavigationStack {
                CanvasView(size: canvasSize, minimumZoomScale: canvasMinimumZoomScale, contentOffset: $contentOffset, zoomScale: $zoomScale) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 25)
                            .fill(.ultraThinMaterial)
                            .onTapGesture {
                                selectedNode = nil
                            }
                        ForEach(nodes) { node in
                            DraggableRoundedRectangle(node: node, selectedNode: $selectedNode, canvasSize: canvasSize)
                        }
                    }
                    .onChange(of: selectedNode) {
                        if let node = selectedNode {
                            self.moveToEnd(node, in: nodes)
                        }
                    }
                }
                .onChange(of: zoomScale) {}
                .ignoresSafeArea()
                .toolbar {
                    ToolbarItem {
                        Button(action: {
                            if zoomScale.isEqual(to: 1) {
                                zoomScale = canvasMinimumZoomScale
                            } else {
                                zoomScale = 1
                            }
                        }) {
                            Label("Reset Zoom", systemImage: zoomScale >= 1 ? "minus.magnifyingglass" : "plus.magnifyingglass")
                        }
                    }
                    ToolbarItem {
                        Menu {
                            ForEach(Value.allCases) { value in
                                Button(value.name) {
                                    addNode(for: value, inside: geometry)
                                }
                            }
                        } label: {
                            Label("Add Node", systemImage: "plus")
                        }
                    }
                    ToolbarItem {
                        Button(action: removeSelected) {
                            Label("Remove Selected Node", systemImage: "minus")
                        }
                        .disabled(selectedNode == nil)
                    }
                }
            }
        }

//        NavigationStack {
//            ScrollView([.horizontal, .vertical]) {
//                ForEach(nodes) { node in
//                    if node.parent == nil {
//                        NodeView(node: node)
//                    }
//                }
//                .onDelete(perform: deleteNodes)
//            }
//            .defaultScrollAnchor(.top)
//            .toolbar {
//                ToolbarItem {
//                    Button(action: { showingAddNodeDialog = true }) {
//                        Label("Add Node", systemImage: "plus")
//                    }
//                }
//            }
//        }
//        .confirmationDialog(
//            "Add Node",
//            isPresented: $showingAddNodeDialog
//        ) {
//            ForEach(Value.allCases) { value in
//                Button(value.name) {
//                    addNode(node: Node.of(type: .intermediate, for: value, inside: nil))
//                }
//            }
//            Button("Cancel", role: .cancel) {}
//        } message: {
//            Text("Choose node to add")
//        }
    }

    func moveToEnd<Element: Orderable>(_ node: Element, in nodes: [Element]) {
        guard let index = nodes.firstIndex(of: node) else {
            return // Item not found in the array
        }

        var nodesCopy = nodes

        // Move the item to the end of the array
        let removedNode = nodesCopy.remove(at: index)
        nodesCopy.append(removedNode)

        // Update the order property of each item to match its new index
        for i in 0 ..< nodesCopy.count {
            nodesCopy[i].order = i
        }
    }

    private func addNode(for value: Value, inside geometry: GeometryProxy) {
        let x = (contentOffset.x + geometry.size.width / 2) / zoomScale - canvasSize.width / 2
        let y = (contentOffset.y + geometry.size.height / 2) / zoomScale - canvasSize.height / 2
        let newNode = Node.of(type: .intermediate, for: value, inside: nil, x: x, y: y, order: nodes.count)
        modelContext.insert(newNode)
        selectedNode = newNode
        print("Added node")
    }

    func removeSelected() {
        guard let selected = selectedNode else { return }
        modelContext.delete(selected)
        selectedNode = nil
    }

//    private func addNode(node: Node, geometry: GeometryProxy) {
//        modelContext.insert(node)
//    }

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
