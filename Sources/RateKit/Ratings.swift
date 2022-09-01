import StoreKit

protocol RatingsRequester {
    func askForRating()
}

struct StoreKitRatings: RatingsRequester {
    func askForRating() {
        SKStoreReviewController.requestReview()
    }
}
