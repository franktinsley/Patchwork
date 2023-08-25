import SwiftUI

struct DraggableRoundedRectangle: View {
    @Environment(\.colorScheme) var colorScheme
    @Bindable var node: Node
    @Binding var selectedNodes: Set<Node>
//    @State private var initialOffset: CGSize
    @State private var someString = ""
//    @State private var shadowRadius: CGFloat = 10
    var canvasSize: CGSize
    let width: CGFloat = 200
    let height: CGFloat = 200

    init(node: Node, selectedNodes: Binding<Set<Node>>, canvasSize: CGSize) {
//        node.initialX = node.x
//        node.initialY = node.y
        self.node = node
        self._selectedNodes = selectedNodes
//        self._initialOffset = State(initialValue: CGSize(width: node.x, height: node.y))
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
            .background {
                ZStack {
                    Rectangle()
                        .fill(.ultraThinMaterial)
                    Rectangle()
                        .fill(selectedNodes.contains(node) ? Color.accentColor : Color.orange)
                        .blendMode(colorScheme == .dark ? .lighten : .darken)
                }
            }
            .scrollContentBackground(.hidden)
        }
        .clipShape(RoundedRectangle(cornerRadius: 25.0))
        .frame(width: width, height: height)
        .offset(CGSize(width: node.x, height: node.y))
        .gesture(DragGesture(minimumDistance: 1)
            .onChanged { value in
                if !selectedNodes.contains(node) {
                    selectedNodes.removeAll()
                    selectedNodes.insert(node)
                }
                for selectedNode in selectedNodes {
                    let newX = selectedNode.initialX + value.translation.width
                    let newY = selectedNode.initialY + value.translation.height

                    selectedNode.x = min(max(-(canvasSize.width / 2) + width / 2, newX), Double(canvasSize.width / 2 - width / 2))
                    selectedNode.y = min(max(-(canvasSize.height / 2) + height / 2, newY), Double(canvasSize.height / 2 - height / 2))
                }
            }
            .onEnded { _ in
                guard selectedNodes.contains(node) else { return }
                for selectedNode in selectedNodes {
                    selectedNode.initialX = selectedNode.x
                    selectedNode.initialY = selectedNode.y
                }
            }
        )
        .onTapGesture {
            if selectedNodes.contains(node) {
                selectedNodes.remove(node)
            } else {
                selectedNodes.insert(node)
            }
        }
        .onChange(of: selectedNodes) {
            if !selectedNodes.contains(node) {
                focusedField = nil
            }
        }
    }
}
