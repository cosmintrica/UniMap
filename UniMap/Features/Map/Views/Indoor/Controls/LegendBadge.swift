//
//  LegendBadge.swift
//  UniMap
//
//  Created by Cosmin Trica on 14.08.2025.
//

import SwiftUI

struct LegendBadge: View {
    let systemImage: String
    let text: String

    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: systemImage)
                .font(.caption.bold())
            Text(text)
                .font(.caption)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(.ultraThinMaterial, in: Capsule())
        .shadow(radius: 2)
    }
}
