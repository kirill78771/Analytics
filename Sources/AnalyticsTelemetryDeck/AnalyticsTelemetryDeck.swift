import Foundation
import AnalyticsCommon
import TelemetryClient

public final class AnalyticsTelemetryDeck: AnalyticsProtocol {

    private let appId: String

    public init(_ appId: String) {
        self.appId = appId
    }
    
    public func send(_ event: AnalyticsCommon.AnalyticsEventProtocol) {
        TelemetryManager.send(event.name, with: event.parameters.plainString)
    }

    public func initialize() {
        let configuration = TelemetryManagerConfiguration(
            appID: appId
        )
        TelemetryManager.initialize(with: configuration)
    }
}
