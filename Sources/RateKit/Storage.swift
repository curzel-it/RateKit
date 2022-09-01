import SwiftUI

protocol RatingsStore {
    var launches: Int { get set }
    var requests: Int { get set }
    var version: String { get set }
    var lastRequest: Date? { get set }
}
        
struct RatingsUserDefaults: RatingsStore {
    private var defaults: UserDefaults? { UserDefaults(suiteName: "Ratings") }
    
    var launches: Int {
        get { defaults?.integer(forKey: "launches") ?? 0 }
        set { defaults?.set(newValue, forKey: "launches") }
    }
    
    var requests: Int {
        get { defaults?.integer(forKey: "requests") ?? 0 }
        set { defaults?.set(newValue, forKey: "requests") }
    }
    
    var version: String {
        get { defaults?.string(forKey: "version") ?? "" }
        set { defaults?.set(newValue, forKey: "version") }
    }
    
    var lastRequest: Date? {
        get {
            guard let time = defaults?.double(forKey: "lastRequestTime") else { return nil }
            return Date(timeIntervalSince1970: time)
        }
        set { defaults?.set(newValue?.timeIntervalSince1970, forKey: "lastRequestTime") }
    }
}
