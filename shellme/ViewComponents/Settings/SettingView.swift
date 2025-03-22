//
//  SettingView.swift
//  shellme
//
//  Created by 斉藤祐大 on 2025/03/16.
//

import SwiftUI

struct SettingView: View {
    let privacyPolicyURL = URL(
        string: "https://okunichiyou.github.io/shellme-docs/privacy-policy")!
    let ossLicenseURL = URL(string: "https://yourosslicenseurl.com")!

    var body: some View {
        List {
            Link("プライバシーポリシー", destination: privacyPolicyURL)

            NavigationLink {
                OssLicencesList()
            } label: {
                Text("OSSライセンス")
            }
        }

    }
}

#Preview {
    SettingView()
}
