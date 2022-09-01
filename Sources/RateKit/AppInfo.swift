import SwiftUI

protocol AppInfoProvider {
    func appVersion() -> String?
}

class BundleInfo: AppInfoProvider {
    func appVersion() -> String? {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    }
}
