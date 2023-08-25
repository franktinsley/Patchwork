import Foundation
import SwiftData

@Model
final class Node: Orderable {
    var name: String?
    var order: Int
    var x: Double
    var y: Double

    private var _type: Int
    var type: NodeType {
        get { NodeType(rawValue: _type)! }
        set { _type = newValue.rawValue }
    }

    private var _value: String?
    var value: Value? {
        get { try! JSONDecoder().decode(Value.self, from: _value!.data(using: .utf8)!) }
        set { _value = try! String(data: JSONEncoder().encode(newValue), encoding: .utf8)! }
    }

    @Relationship(deleteRule: .cascade) var inputs: [Node]
    @Relationship(deleteRule: .cascade) var outputs: [Node]

    var parent: Node?
    var start: Node?
    @Relationship(deleteRule: .cascade) var children: [Node]
    var connections: [Node]

    init(name: String? = nil, order: Int = 0, x: Double = 100, y: Double = 100, type: NodeType = .input, value: Value? = nil, inputs: [Node] = [], outputs: [Node] = [], parent: Node? = nil, start: Node? = nil, children: [Node] = [], connections: [Node] = []) {
        self.name = name
        self.order = order
        self.x = x
        self.y = y
        self._type = type.rawValue
        self._value = try! String(data: JSONEncoder().encode(value), encoding: .utf8)!
        self.inputs = inputs
        self.outputs = outputs
        self.parent = parent
        self.start = start
        self.children = children
        self.connections = connections
    }
}

extension Node {
    var metal: String {
        switch type {
        case .input:
            "\(value?.name ?? "NO_VALUE") \(name ?? "NO_NAME")"
        case .intermediate:
            "intermediate"
        case .output:
            "output"
        case .function:
            "\(value?.name ?? "void") \(name ?? "NO_NAME")(\(inputs.map { $0.metal }.joined(separator: ", "))) \(start?.metal ?? "")"
        }
    }

    static var preview: Node {
//        Node(type: .intermediate)
        Node(
            name: "UV",
            type: .function,
            value: .float2(0, 0)
        )
    }

    static func of(type: NodeType, for value: Value, inside parent: Node?, x: Double, y: Double, order: Int) -> Node {
        Node(name: value.name, order: order, x: x, y: y, type: type, value: value, parent: parent)
    }
}
