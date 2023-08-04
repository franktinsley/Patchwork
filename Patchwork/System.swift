import SwiftData

@Model
final class System {
    var modules: [Module]
    var connections: [Connection]

    init(modules: [Module], connections: [Connection]) {
        self.modules = modules
        self.connections = connections
    }
}

extension System {
    var metal: String { "System Metal\nModules:\n\(self.modules.map { $0.metal }.joined(separator: "\n"))" }
}
