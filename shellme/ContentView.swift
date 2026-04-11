//
//  ContentView.swift
//  shellme
//
//  Created by 斉藤祐大 on 2025/01/19.
//

import AppTrackingTransparency
import GoogleMobileAds
import SwiftUI

struct ContentView: View {
    init() {
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIColor.systemPink

        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.white
        ]

        let backButtonAppearance = UIBarButtonItemAppearance()
        backButtonAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor.white
        ]
        appearance.backButtonAppearance = backButtonAppearance

        let backImage = UIImage(systemName: "chevron.backward")?.withTintColor(
            .white, renderingMode: .alwaysOriginal)
        appearance.setBackIndicatorImage(
            backImage, transitionMaskImage: backImage)

        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }

    var body: some View {
        NavigationStack {
            IndexItemView()
        }
        .onReceive(
            NotificationCenter.default.publisher(
                for: UIApplication.didBecomeActiveNotification)
        ) { _ in
            OperationQueue.main.addOperation {
                ATTrackingManager.requestTrackingAuthorization(
                    completionHandler: {
                        _ in
                    })
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(SampleData.shared.modelContainer)
}
