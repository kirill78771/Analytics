import Foundation
import AnalyticsCommon
import TelemetryClient

public final class AnalyticsTelemetryDeck: AnalyticsProtocol {

    private let appId: String

    public init(_ appId: String) {
        self.appId = appId
    }
    
    public func send(_ event: AnalyticsCommon.AnalyticsEventProtocol) {
        TelemetryDeck.signal(event.name, parameters: event.parameters.plainString)
    }

    public func initialize() {
        TelemetryDeck.initialize(config: .init(appID: appId))
    }
}
