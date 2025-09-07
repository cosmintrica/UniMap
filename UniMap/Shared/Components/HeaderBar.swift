//
//  HeaderBar.swift
//  UniMap
//
//  Created by Cosmin Trica on 13.08.2025.
//


import SwiftUI

struct HeaderBar: View {
    @Binding var institution: Institution

    var body: some View {
        HStack(spacing: 12) {
            // Brand
            HStack(spacing: 8) {
                Image("unimapIcon")
                    .resizable()
                    .frame(width: 22, height: 22)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                    .accessibilityHidden(true)

                Text("UniMap")
                    .font(.title3.bold())
                    .accessibilityAddTraits(.isHeader)
            }

            Spacer()

            // Selector instituție (meniu)
            Picker("Instituție", selection: $institution) {
                ForEach(Institution.allCases, id: \.self) {
                    Text($0.displayName).tag($0)
                }
            }
            .pickerStyle(.menu)
            .accessibilityLabel("Alege instituția")
        }
        .padding(.horizontal)
        .contentShape(Rectangle()) // hit-area mai iertătoare
    }
}

#Preview {
    @Previewable @State var inst: Institution = .ucv
    return HeaderBar(institution: $inst)
        .padding()
}
