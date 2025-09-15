import Foundation
@preconcurrency import Amplitude
import AnalyticsCommon

public final class AnalyticsAmplitude: AnalyticsProtocol {

    private let userId: String
    private let apiKey: String
    private let amplitude = Amplitude.instance()

    public init(
        userId: String,
        apiKey: String
    ) {
        self.userId = userId
        self.apiKey = apiKey
    }

    public func initialize() {
        amplitude.defaultTracking.sessions = true
        amplitude.initializeApiKey(apiKey)
        amplitude.setUserId(userId)
    }

    public func send(_ event: AnalyticsEventProtocol) {
        amplitude.logEvent(
            event.name,
            withEventProperties: event.parameters.plain
        )
    }
}
