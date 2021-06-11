import Foundation

public enum Universe: String {
    case women
    case men
    
    public init(rawValue: String) {
        if rawValue == "homme" || rawValue == "men" {
            self = .men
        } else {
            self = .women
        }
    }
}
