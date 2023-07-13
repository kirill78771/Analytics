import Foundation

public protocol AnalyticsEventProtocol {
    var name: String { get }
    var parameters: [String: AnalyticsEventParameter] { get }
}

public enum AnalyticsEventParameter {
    case string(String)
    case int(Int)
    case double(Double)
    case float(CGFloat)
    case bool(Bool)

    public var rawValue: Any {
        switch self {
        case .string(let string):
            return string
        case .int(let int):
            return int
        case .double(let double):
            return double
        case .float(let float):
            return float
        case .bool(let bool):
            return bool
        }
    }
}

extension Dictionary where Key == String, Value == AnalyticsEventParameter {
    public var plain: [String: Any] {
        mapValues(\.rawValue)
    }

    public var plainString: [String: String] {
        mapValues { value in
            "\(value.rawValue)"
        }
    }
}

public struct AnalyticsEvent: AnalyticsEventProtocol {
    public let name: String
    public let parameters: [String: AnalyticsEventParameter]

    public init(
        name: String,
        parameters: [String: AnalyticsEventParameter] = [:]
    ) {
        self.name = name
        self.parameters = parameters
    }
}
