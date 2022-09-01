import SwiftUI

public protocol RatingsService {
    
    /// Will prompt the user to rate the app after a certain number of calls.
    /// - Parameters:
    ///     - debug: Enables logging.
    ///     - launchesBeforeAskingForReview: Number of times this method needs to be called before any prompt is shown. Default 5.
    ///     - maxRequestsPerVersion: Number of prompts that will be shown for each app version. Default 1.
    @discardableResult
    func askForRatingIfNeeded() -> Bool
    
    /// Will prompt the user to rate the app immediately.
    func askForRating()
}

public enum RateKit {
    
    public static func ratingsService(
        debug: Bool = false,
        launchesBeforeAskingForReview: Int = 5,
        maxRequestsPerVersion: Int = 1
    ) -> RatingsService {
        RatingsServiceImpl(
            debug: debug,
            store: RatingsUserDefaults(),
            requester: StoreKitRatings(),
            appInfo: BundleInfo(),
            launchesBeforeAskingForReview: launchesBeforeAskingForReview,
            maxRequestsPerVersion: maxRequestsPerVersion
        )
    }
}

class RatingsServiceImpl: RatingsService {
    var store: RatingsStore
    var requester: RatingsRequester
    var appInfo: AppInfoProvider
    let debug: Bool
    let launchesBeforeAskingForReview: Int
    let maxRequestsPerVersion: Int
    
    init(
        debug: Bool,
        store: RatingsStore,
        requester: RatingsRequester,
        appInfo: AppInfoProvider,
        launchesBeforeAskingForReview: Int = 5,
        maxRequestsPerVersion: Int = 1
    ) {
        self.debug = debug
        self.store = store
        self.requester = requester
        self.appInfo = appInfo
        self.launchesBeforeAskingForReview = launchesBeforeAskingForReview
        self.maxRequestsPerVersion = maxRequestsPerVersion
    }
    
    @discardableResult
    func askForRatingIfNeeded() -> Bool {
        guard canAskForRating() else { return false }
        askForRating()
        return true
    }
    
    func askForRating() {
        log("Asking for ratings...")
        store.requests += 1
        requester.askForRating()
    }
    
    func canAskForRating() -> Bool {
        appLaunched(withVersion: appInfo.appVersion() ?? "")
        
        guard store.launches >= launchesBeforeAskingForReview else {
            let missingLaunches = launchesBeforeAskingForReview - store.launches
            log("\(missingLaunches) more launches required before rate request...")
            return false
        }
        guard store.requests < maxRequestsPerVersion else {
            log("Skipping request, already asked \(store.requests) times...")
            return false
        }
        return true
    }
    
    private func appLaunched(withVersion currentVersion: String) {
        if store.version != currentVersion {
            store.version = currentVersion
            store.requests = 0
            store.launches = 0
        }
        store.launches += 1
    }
    
    private func log(_ string: String) {
        guard debug else { return }
        let df = DateFormatter()
        df.dateFormat = "HH:mm:ss.SSS"
        let timestamp = df.string(from: Date())
        print("\(timestamp) [Ratings] \(string)")
    }
}
