import SwiftData

@Model
final class Connection {
    var from: Port?
    var to: Port?
    
    init(from: Port? = nil, to: Port? = nil) {
        self.from = from
        self.to = to
    }
}
