import UIKit

private var tracksAppearanceMethodsKey: UInt8 = 0
private var trackingScreenNameKey: UInt8 = 0
private var trackingAdditionalParametersKey: UInt8 = 0

extension UIViewController {

    private static var analytics: AnalyticsProtocol?

    public var trackingAdditionalParameters: [String: AnalyticsEventParameter] {
        get {
            objc_getAssociatedObject(self, &trackingAdditionalParametersKey) as? [String: AnalyticsEventParameter] ?? [:]
        }
        set {
            objc_setAssociatedObject(self, &trackingAdditionalParametersKey, newValue as AnyObject, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    public var tracksAppearanceMethods: Bool {
        get {
            objc_getAssociatedObject(self, &tracksAppearanceMethodsKey) as? Bool ?? false
        }
        set {
            objc_setAssociatedObject(self, &tracksAppearanceMethodsKey, newValue as AnyObject, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    public var trackingScreenName: String {
        get {
            objc_getAssociatedObject(self, &trackingScreenNameKey) as? String ?? getAnalyticsScreenType()
        }
        set {
            objc_setAssociatedObject(self, &trackingScreenNameKey, newValue as AnyObject, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    public static func enableAutomaticAppearanceTracking(
        with analytics: AnalyticsProtocol
    ) {
        self.analytics = analytics
        guard self == UIViewController.self else {
            return
        }
        let _: Void = {
            let originalSelector = #selector(UIViewController.viewWillAppear(_:))
            let swizzledSelector = #selector(UIViewController.tracked_viewWillAppear(_:))
            guard
                let originalMethod = class_getInstanceMethod(self, originalSelector),
                let swizzledMethod = class_getInstanceMethod(self, swizzledSelector)
            else {
                assertionFailure()
                return
            }
            method_exchangeImplementations(originalMethod, swizzledMethod)
        }()
        let _: Void = {
            let originalSelector = #selector(UIViewController.viewDidDisappear(_:))
            let swizzledSelector = #selector(UIViewController.tracked_viewDidDisappear(_:))
            guard
                let originalMethod = class_getInstanceMethod(self, originalSelector),
                let swizzledMethod = class_getInstanceMethod(self, swizzledSelector)
            else {
                assertionFailure()
                return
            }
            method_exchangeImplementations(originalMethod, swizzledMethod)
        }()
    }

    @objc dynamic func tracked_viewWillAppear(_ animated: Bool) {
        tracked_viewWillAppear(animated)
        guard tracksAppearanceMethods else {
            return
        }
        let parameters: [String: AnalyticsEventParameter] = [
            "view_type": .string(trackingScreenName)
        ].merging(trackingAdditionalParameters, uniquingKeysWith: { $1 })
        let event = AnalyticsEvent(
            name: "screen_appeared",
            parameters: parameters
        )
        Self.analytics?.send(event)
    }

    @objc dynamic func tracked_viewDidDisappear(_ animated: Bool) {
        tracked_viewDidDisappear(animated)
        guard tracksAppearanceMethods else {
            return
        }
        let parameters: [String: AnalyticsEventParameter] = [
            "view_type": .string(trackingScreenName)
        ].merging(trackingAdditionalParameters, uniquingKeysWith: { $1 })
        let event = AnalyticsEvent(
            name: "screen_disappeared",
            parameters: parameters
        )
        Self.analytics?.send(event)
    }

    private func getAnalyticsScreenType() -> String {
        let rawString = String(reflecting: type(of: self))
        let components = rawString.components(separatedBy: ".")
        return components.last ?? rawString
    }
}
