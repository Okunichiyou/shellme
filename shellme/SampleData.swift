//
//  ItemSample.swift
//  shellme
//
//  Created by 斉藤祐大 on 2025/02/02.
//

import Foundation
import SwiftData

@MainActor
class SampleData {
    static let shared = SampleData()

    let modelContainer: ModelContainer

    var context: ModelContext {
        modelContainer.mainContext
    }
    
    var item: Item {
        Item.sampleData.first!
    }

    private init() {
        let schema = Schema([
            Item.self
        ])
        let modelConfiguration = ModelConfiguration(
            schema: schema, isStoredInMemoryOnly: true)

        do {
            modelContainer = try ModelContainer(
                for: schema, configurations: [modelConfiguration])
            insertSampleData()
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }

    private func insertSampleData() {
        for item in Item.sampleData {
            context.insert(item)
        }
    }
}
