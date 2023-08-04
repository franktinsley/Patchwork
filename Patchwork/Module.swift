import Foundation
import SwiftData

@Model
final class Module {
    var name: String?

    private var _type: String?
    var type: Value? {
        get { try! JSONDecoder().decode(Value.self, from: _type!.data(using: .utf8)!) }
        set { _type = try! String(data: JSONEncoder().encode(newValue), encoding: .utf8)! }
    }

    var inputs: [Input]
    var outputs: [Output]

    var parent: Module?
    var positionX: Float
    var positionY: Float

    @Relationship(.cascade) var children: [Module]
    @Relationship(.cascade) var connections: [Connection]

    init(
        name: String? = nil,
        type: Value? = nil,
        inputs: [Input] = [],
        outputs: [Output] = [],
        parent: Module? = nil,
        positionX: Float = 0,
        positionY: Float = 0,
        children: [Module] = [],
        connections: [Connection] = []
    ) {
        self.name = name
        self.type = type
        self.inputs = inputs
        self.outputs = outputs
        self.parent = parent
        self.positionX = positionX
        self.positionY = positionY
        self.children = children
        self.connections = connections
    }
}

extension Module {
    var metal: String { "\(self)" }

    static var preview: Module {
        Module(name: "My Module")
    }
}
