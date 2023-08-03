import SwiftData

@Model
final class System {
    var nodes: [Node]
    var connections: [Connection]
    
    init(nodes: [Node], connections: [Connection]) {
        self.nodes = nodes
        self.connections = connections
    }
}

extension System {
    var metal: String { "System Metal\nNodes:\n\(self.nodes.map { $0.metal }.joined(separator: "\n"))" }
}
