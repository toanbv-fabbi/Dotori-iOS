import BaseFeatureInterface
import Moordinator
import UIKit

public enum DotoriRoutePath: RoutePath {
    // MARK: Global
    case alert(
        title: String? = nil,
        message: String? = nil,
        style: UIAlertController.Style = .alert,
        actions: [UIAlertAction] = []
    )
    case confirmationDialog(
        title: String = "",
        message: String = "",
        confirmAction: () async -> Void
    )
    case inputDialog(
        title: String,
        placeholder: String,
        inputType: DialogInputType,
        confirmAction: (String) async -> Void
    )
    case dismiss
    case pop

    // MARK: Auth
    case splash
    case signin
    case signup
    case findID
    case renewalPassword
    case main

    // MARK: Home
    case home
    case myInfoActionSheet
    case myViolationList

    // MARK: Notice
    case notice
    case noticeDetail(noticeID: Int)

    // MARK: SelfStudy
    case selfStudy

    // MARK: Massage
    case massage

    // MARK: Music
    case music
    case proposeMusic
    case youtube
    case youtubeByID(id: String)
}

public extension RoutePath {
    var asDotori: DotoriRoutePath? {
        self as? DotoriRoutePath
    }
}
