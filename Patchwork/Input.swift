import Foundation
import SwiftData

@Model
final class Input {
    var name: String?
    var connection: Connection?

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

extension Input {
    var metal: String { "Input\nValue:\n\(value?.metal ?? "")" }

    static var preview: Input {
        Input(name: "My Input", value: .bool(false))
    }
}
