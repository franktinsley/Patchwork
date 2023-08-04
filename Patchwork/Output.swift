import Foundation
import SwiftData

@Model
final class Output {
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

extension Output {
    var metal: String { "Output\nValue:\n\(value?.metal ?? "")" }
    
    static var preview: Output {
        Output(name: "Mu Output", value: .bool(false))
    }
}
