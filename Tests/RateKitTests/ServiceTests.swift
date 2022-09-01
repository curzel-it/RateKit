import XCTest

@testable import RateKit

class ServiceTests: XCTestCase {
        
    var service: RatingsServiceImpl!
    var mockRequester: MockRequester { service.requester as! MockRequester }
    
    override func setUp() {
        service = RatingsServiceImpl(
            debug: true,
            store: MockStore(),
            requester: MockRequester(),
            appInfo: MockAppInfo(version: "1.0.0"),
            launchesBeforeAskingForReview: 3,
            maxRequestsPerVersion: 3
        )
    }
    
    func testAskingServiceForRatingsIncreasesLaunchesCount() {
        service.askForRatingIfNeeded()
        XCTAssertEqual(service.store.launches, 1)
        XCTAssertEqual(service.store.requests, 0)
        XCTAssertEqual(mockRequester.numberOfRequests, 0)
    }
    
    func testRequestIsNotFiredIfLaunchesConditionAreNotMet() {
        service.askForRatingIfNeeded()
        service.askForRatingIfNeeded()
        service.askForRatingIfNeeded()
        XCTAssertEqual(service.store.launches, 3)
        XCTAssertEqual(service.store.requests, 1)
        XCTAssertEqual(mockRequester.numberOfRequests, 1)
    }
    
    func testRequestIsNotFiredIfRequestsConditionAreNotMet() {
        service.askForRatingIfNeeded()
        service.askForRatingIfNeeded()
        service.askForRatingIfNeeded()
        XCTAssertEqual(mockRequester.numberOfRequests, 1)
        XCTAssertEqual(service.store.requests, 1)
        service.askForRatingIfNeeded()
        XCTAssertEqual(mockRequester.numberOfRequests, 2)
        XCTAssertEqual(service.store.requests, 2)
        service.askForRatingIfNeeded()
        XCTAssertEqual(mockRequester.numberOfRequests, 3)
        XCTAssertEqual(service.store.requests, 3)
        service.askForRatingIfNeeded()
        XCTAssertEqual(mockRequester.numberOfRequests, 3)
        XCTAssertEqual(service.store.requests, 3)
    }
    
    func testChangeInAppVersionResetsLaunchesAndRequests() {
        service.askForRatingIfNeeded()
        service.askForRatingIfNeeded()
        service.askForRatingIfNeeded()
        XCTAssertEqual(service.store.requests, 1)
        service.askForRatingIfNeeded()
        service.askForRatingIfNeeded()
        XCTAssertEqual(mockRequester.numberOfRequests, 3)
        XCTAssertEqual(service.store.requests, 3)
        service.appInfo = MockAppInfo(version: "2.0.0")
        service.askForRatingIfNeeded()
        XCTAssertEqual(service.store.launches, 1)
        XCTAssertEqual(service.store.requests, 0)
        XCTAssertEqual(mockRequester.numberOfRequests, 3)
    }
}
