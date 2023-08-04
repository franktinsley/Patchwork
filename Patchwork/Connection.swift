import SwiftData

@Model
final class Connection {
    var from: Output?
    var to: Input?

    init(from: Output? = nil, to: Input? = nil) {
        self.from = from
        self.to = to
    }
}
