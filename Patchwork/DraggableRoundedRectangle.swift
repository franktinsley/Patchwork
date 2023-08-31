import SwiftUI

struct DraggableRoundedRectangle: View {
    @Environment(\.colorScheme) var colorScheme
    @Bindable var node: Node
    @Binding var selectedNodes: Set<Node>
    @Binding var draggingNode: Node?
    @State private var someString = ""
    @State private var dragStartLocation = CGPoint.zero
    @State private var dragging = false
    var canvasSize: CGSize
    let width: CGFloat = 200
    let height: CGFloat = 200

    init(node: Node, selectedNodes: Binding<Set<Node>>, draggingNode: Binding<Node?>, canvasSize: CGSize) {
        self.node = node
        self._selectedNodes = selectedNodes
        self._draggingNode = draggingNode
        self.canvasSize = canvasSize
    }

    enum Field: Hashable {
        case textField
    }

    @FocusState private var focusedField: Field?

    var body: some View {
        ZStack {
            Form {
                TextField("Whatever", text: $someString)
                    .focused($focusedField, equals: .textField)
                Text(node.value?.name ?? "Some Node")
            }
            .scrollDisabled(true)
            .clipShape(RoundedRectangle(cornerRadius: 25))
            .background {
                ZStack {
                    RoundedRectangle(cornerRadius: 25)
                        .fill(.ultraThinMaterial)
                    RoundedRectangle(cornerRadius: 25)
                        .fill(selectedNodes.contains(node) ? Color.accentColor : node.type.color)
                        .blendMode(colorScheme == .dark ? .lighten : .darken)
                }
            }
            .scrollContentBackground(.hidden)
        }
        .frame(width: width, height: height)
        .offset(CGSize(width: node.x, height: node.y))
        .gesture(DragGesture(minimumDistance: 1)
            .onChanged { value in
                if draggingNode == nil { // no primary dragging node yet
                    draggingNode = node // make this node the priomary dragging node
                } else if draggingNode != node {
                    return // Don't do anything if this drag is happening on a node that isn't the primary dragging node
                }

                if !dragging {
                    dragging = true // onDragBegin
                    if selectedNodes.isEmpty { // No nodes yet selected
                        dragStartLocation = value.startLocation // Store the single primary drag's start location as the actual drag gesture's start location
                    } else {
                        dragStartLocation = value.location // There are currently nodes select so we need to restart the drag start location so the new nodes get moved starting from here
                    }
                }

                if !selectedNodes.contains(node) { // This node is being dragged but is not yet selected
                    selectedNodes.removeAll() // Deselect all nodes
                    selectedNodes.insert(node) // Select this node
                }

                for selectedNode in selectedNodes {
                    let newX = selectedNode.initialX + value.location.x - dragStartLocation.x
                    let newY = selectedNode.initialY + value.location.y - dragStartLocation.y

                    selectedNode.x = min(max(-(canvasSize.width / 2) + width / 2, newX), Double(canvasSize.width / 2 - width / 2))
                    selectedNode.y = min(max(-(canvasSize.height / 2) + height / 2, newY), Double(canvasSize.height / 2 - height / 2))
                }
            }
            .onEnded { _ in
                if draggingNode == node {
                    draggingNode = nil
                    dragging = false
                    guard selectedNodes.contains(node) else { return }
                    for selectedNode in selectedNodes {
                        selectedNode.initialX = selectedNode.x
                        selectedNode.initialY = selectedNode.y
                    }
                }
            })
        .onTapGesture {
            if draggingNode == nil { // not dragging any node
                selectedNodes.removeAll() // deselect all nodes
                selectedNodes.insert(node) // select this node
            } else {
                if selectedNodes.contains(node) { // node is selected
                    selectedNodes.remove(node) // unselect node
                } else {
                    selectedNodes.insert(node) // select node
                }
            }
        }
        .onChange(of: selectedNodes) {
            dragging = false
            for selectedNode in selectedNodes {
                selectedNode.initialX = selectedNode.x
                selectedNode.initialY = selectedNode.y
            }
            if !selectedNodes.contains(node) {
                focusedField = nil
            }
        }
    }
}
