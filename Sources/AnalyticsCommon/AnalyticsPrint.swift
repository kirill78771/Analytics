import Foundation

public final class AnalyticsPrint: AnalyticsProtocol {

    private let printAction: @Sendable (String) -> Void

    public init(printAction: @escaping @Sendable (String) -> Void) {
        self.printAction = printAction
    }

    public func initialize() { }

    public func send(_ event: AnalyticsEventProtocol) {
        printAction("[📊] eventName: \(event.name)\nparameters: \(event.parameters.plain)")
    }
}
