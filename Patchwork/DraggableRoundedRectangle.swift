import SwiftUI

struct DraggableRoundedRectangle: View {
    @Environment(\.colorScheme) var colorScheme
    @Bindable var node: Node
    @Binding var selectedNode: Node?
    @State private var initialOffset: CGSize
    @State private var someString = ""
//    @State private var shadowRadius: CGFloat = 10
    var canvasSize: CGSize
    let width: CGFloat = 200
    let height: CGFloat = 200

    init(node: Node, selectedNode: Binding<Node?>, canvasSize: CGSize) {
        self.node = node
        self._selectedNode = selectedNode
        self._initialOffset = State(initialValue: CGSize(width: node.x, height: node.y))
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
                        .fill(selectedNode === node ? Color.accentColor : Color.orange)
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
                self.selectedNode = self.node
                let newX = self.initialOffset.width + value.translation.width
                let newY = self.initialOffset.height + value.translation.height

                self.node.x = min(max(-(canvasSize.width / 2) + width / 2, newX), Double(canvasSize.width / 2 - width / 2))
                self.node.y = min(max(-(canvasSize.height / 2) + height / 2, newY), Double(canvasSize.height / 2 - height / 2))
            }
            .onEnded { _ in
                self.initialOffset.width = self.node.x
                self.initialOffset.height = self.node.y
            }
        )
        .onTapGesture {
            selectedNode = node
        }
        .onChange(of: selectedNode) {
            if selectedNode !== node {
                focusedField = nil
            }
        }
    }
}
