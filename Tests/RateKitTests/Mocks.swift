import XCTest

@testable import RateKit

class MockAppInfo: AppInfoProvider {
    var version: String?
    
    init(version: String?) {
        self.version = version
    }
    
    func appVersion() -> String? { version }
}

class MockStore: RatingsStore {
    var launches: Int
    var requests: Int
    var version: String
    
    init(launches: Int = 0, requests: Int = 0, version: String = "") {
        self.launches = launches
        self.requests = requests
        self.version = version
    }
}

class MockRequester: RatingsRequester {
    var numberOfRequests: Int = 0
    
    func askForRating() {
        numberOfRequests += 1
    }
}
