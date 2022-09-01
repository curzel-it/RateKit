import SwiftUI

protocol RatingsStore {
    var launches: Int { get set }
    var requests: Int { get set }
    var version: String { get set }
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
}
