import Foundation
import SwiftData

@Model
final class Port {
    var name: String?
    var connections: [Connection]?

    private var _value: String?
    var value: Value? {
        get { try! JSONDecoder().decode(Value.self, from: _value!.data(using: .utf8)!) }
        set { _value = try! String(data: JSONEncoder().encode(newValue), encoding: .utf8)! }
    }
    
    init(name: String? = nil, value: Value? = nil) {
        self.name = name
        self.value = value
    }
}

extension Port {
    var metal: String { "Port\nValue:\n\(self.value?.metal ?? "")" }
}
