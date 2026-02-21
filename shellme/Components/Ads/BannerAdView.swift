//
//  BannerAdView.swift
//  shellme
//
//  Created by 斉藤祐大 on 2025/03/16.
//

import GoogleMobileAds
import SwiftUI

struct BannerAdView: UIViewRepresentable {
    func makeUIView(context: Context) -> BannerView {
        let banner = BannerView(adSize: AdSizeBanner)

        guard let id = adUnitID(key: "banner") else {
            print("Ad Unit ID not found")
            return banner
        }

        banner.adUnitID = id
        banner.rootViewController = findRootViewController()

        let request = Request()
        banner.load(request)

        return banner
    }

    func updateUIView(_ uiView: BannerView, context: Context) {
        print("update UI VIEW")
    }

    private func adUnitID(key: String) -> String? {
        (Bundle.main.object(forInfoDictionaryKey: "AdUnitIDs")
            as? [String: String])?[key]
    }

    private func findRootViewController() -> UIViewController? {
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first(where: { $0.isKeyWindow })?.rootViewController
    }
}
