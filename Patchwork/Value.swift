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

extension Value {
    var metal: String {
        switch self {
        case .order: "order"
        case .bool(let bool): bool.description
        case .int(let int): int.description
        default: "Some Value"
        }
    }
}
