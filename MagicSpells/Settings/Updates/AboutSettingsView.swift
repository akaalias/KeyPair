//
//  AboutSettingsView.swift
//  Poppy
//
//  Created by Alexis Rondeau on 09.06.23.
//

import SwiftUI

struct AboutSettingsView: View {
    var body: some View {
        VStack {
            Text("KeyPair")
                .font(.largeTitle)
                .padding(8)

            Text("KeyPair is [free and open software](https://github.com/akaalias/keypair) made with ❤️ by [Alexis Rondeau](https://alexisrondeau.me)")
                .font(.body)
                .padding(8)
        }
    }
}

struct AboutSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        AboutSettingsView()
    }
}

extension Bundle {
    var releaseVersionNumber: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
    var buildVersionNumber: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }
}

