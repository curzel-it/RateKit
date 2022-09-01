# RateKit

[![macOS](https://img.shields.io/badge/OS-macOS-green.svg)](https://developer.apple.com/macos/)
[![iOS](https://img.shields.io/badge/OS-iOS-green.svg)](https://developer.apple.com/ios/)

RateKit is a simple utility to prompt the users of your iOS or macOS apps to submit a review after a certain number of runs.

This utility by default will not immediatly ask the user to review the app, instead, it will keeps counting until a minimum threshold of calls is hit. 
Only then, the user will be prompted for a review.
You can also configure the number of times the user should be prompted for each app version. 

# Usage

Place this where it best fits your use case:

```swift
let ratingsService = RatingsService.build()
ratingsService.askForRatingIfNeeded()
```

You can also show the ratings prompt immediately:

```swift
RatingsService.build().askForRating()
```

Finally, if you want to use different thresholds or enable logging:

```swift
let ratingsService = RatingsService.build(
    debug: true,
    launchesBeforeAskingForReview: 5,
    maxRequestsPerVersion: 1
)
ratingsService.askForRatingIfNeeded()

```

