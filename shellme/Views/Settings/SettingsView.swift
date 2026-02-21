//
//  SettingView.swift
//  shellme
//
//  Created by 斉藤祐大 on 2025/03/16.
//

import SwiftUI

struct SettingsView: View {
    let privacyPolicyURL = URL(
        string: "https://okunichiyou.github.io/shellme-docs/privacy-policy")!
    let ossLicenseURL = URL(string: "https://yourosslicenseurl.com")!

    var body: some View {
        List {
            Link("プライバシーポリシー", destination: privacyPolicyURL)

            NavigationLink {
                OssLicencesListView()
            } label: {
                Text("OSSライセンス")
            }
        }

    }
}

#Preview {
    SettingsView()
}
