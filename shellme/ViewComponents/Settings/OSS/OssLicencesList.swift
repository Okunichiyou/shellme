//
//  OssLicencesList.swift
//  shellme
//
//  Created by 斉藤祐大 on 2025/03/17.
//

import LicenseList
import SwiftUI

struct OssLicencesList: View {
    var body: some View {
        LicenseListView()
            .licenseViewStyle(.withRepositoryAnchorLink)
            .navigationTitle("OSSライセンス")
            .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    OssLicencesList()
}
