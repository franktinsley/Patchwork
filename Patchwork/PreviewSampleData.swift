import SwiftData
import SwiftUI

actor PreviewSampleData {
    @MainActor
    static var container: ModelContainer = {
        let schema = Schema([Node.self])
        let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: schema, configurations: [configuration])
        let previewNode = Node(
            name: "UV",
            type: .function,
            value: .float2(0, 0)
        )
        container.mainContext.insert(previewNode)
        previewNode.inputs.append(contentsOf: [
            Node(
                name: "pixelPosition",
                type: .input,
                value: .int2(0, 0),
                parent: previewNode
            ),
            Node(
                name: "textureSize",
                type: .input,
                value: .int2(0, 0),
                parent: previewNode
            )
        ])
        previewNode.start = Node(
            type: .input,
            value: .order,
            parent: previewNode
        )
        print(previewNode.metal)
        return container
    }()
}
