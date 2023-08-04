import Foundation
import SwiftData

@Model
final class Node {
    var name: String?

    private var _type: String?
    var type: Value? {
        get { try! JSONDecoder().decode(Value.self, from: _type!.data(using: .utf8)!) }
        set { _type = try! String(data: JSONEncoder().encode(newValue), encoding: .utf8)! }
    }

    var inputs: [Input]
    var outputs: [Output]

    init(name: String? = nil, type: Value? = nil, inputs: [Input] = [], outputs: [Output] = []) {
        self.name = name
        self.type = type
        self.inputs = inputs
        self.outputs = outputs
    }
}

extension Node {
    var metal: String { "Node\nInputs:\n\(inputs.map { $0.metal }.joined(separator: "\n"))\nOutputs:\n\(outputs.map { $0.metal }.joined(separator: "\n"))" }
}
