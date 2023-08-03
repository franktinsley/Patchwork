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
    
    var inputs: [Port]
    var outputs: [Port]
    
    init(name: String? = nil, type: Value? = nil, inputs: [Port] = [], outputs: [Port] = []) {
        self.name = name
        self.type = type
        self.inputs = inputs
        self.outputs = outputs
    }
}

extension Node {
    var metal: String { "Node\nInputs:\n\(self.inputs.map { $0.metal }.joined(separator: "\n"))\nOutputs:\n\(self.outputs.map { $0.metal }.joined(separator: "\n"))" }
}
