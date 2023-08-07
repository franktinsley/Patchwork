import Foundation

enum Value: Codable {
    case order
    case bool(Bool)
    case int(Int)
    case int2(Int, Int)
    case int3(Int, Int, Int)
    case int4(Int, Int, Int, Int)
    case float(Float)
    case float2(Float, Float)
    case float3(Float, Float, Float)
    case float4(Float, Float, Float, Float)
    case string(String)
}

extension Value: Hashable, Identifiable {
    var id: Self { self }
}

extension Value: CaseIterable {
    static var allCases: [Value] {
        [
            .order,
            .bool(false),
            .int(0),
            .int2(0, 0),
            .int3(0, 0, 0),
            .int4(0, 0, 0, 0),
            .float(0),
            .float2(0, 0),
            .float3(0, 0, 0),
            .float4(0, 0, 0, 0),
            .string("")
        ]
    }
}

extension Value {
    var name: String {
        switch self {
        case .order: "Order"
        case .bool: "Bool"
        case .int: "Int"
        case .int2: "Int2"
        case .int3: "Int3"
        case .int4: "Int4"
        case .float: "Float"
        case .float2: "Float2"
        case .float3: "Float3"
        case .float4: "Float4"
        case .string: "String"
        }
    }
    
    var metal: String {
        switch self {
        case .order: "order"
        case .bool(let bool): bool.description
        case .int(let int): int.description
        default: "Some Value"
        }
    }
}
