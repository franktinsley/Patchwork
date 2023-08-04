import SwiftData
import SwiftUI

actor PreviewSampleData {
    @MainActor
    static var container: ModelContainer = {
        let schema = Schema([Module.self, Input.self, Output.self, Connection.self])
        let configuration = ModelConfiguration(inMemory: true)
        let container = try! ModelContainer(for: schema, configurations: [configuration])
        let sampleData: [any PersistentModel] = [
            Module.preview, Input.preview, Output.preview
        ]
        sampleData.forEach {
            container.mainContext.insert($0)
        }
        return container
    }()
}
