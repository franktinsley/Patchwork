import SwiftUI

enum NodeType: Int, CaseIterable {
    case input
    case intermediate
    case output
    case function
}

extension NodeType {
    var color: Color {
        switch self {
        case .input, .output: .gray
        case .intermediate: .orange
        case .function: .purple
        }
    }
}
