import Foundation

public protocol AnalyticsProtocol: AnyObject, Sendable {
    func send(_ event: AnalyticsEventProtocol)
    func initialize()
}

public final class CompositionAnalytics: AnalyticsProtocol {

    private let analytics: [AnalyticsProtocol]

    public init(analytics: [AnalyticsProtocol]) {
        self.analytics = analytics
        initialize()
    }

    public func send(_ event: AnalyticsEventProtocol) {
        analytics.forEach { $0.send(event) }
    }

    public func initialize() {
        analytics.forEach { $0.initialize() }
    }
}
