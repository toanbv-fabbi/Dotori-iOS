import BaseFeature
import Combine
import ConfirmationDialogFeature
import MainTabFeature
import Moordinator
import SigninFeature
import SplashFeature
import UIKit
import UIKitUtil

public final class RootMoordinator: Moordinator {
    private let window: UIWindow
    private let splashFactory: any SplashFactory
    private let signinFactory: any SigninFactory
    private let mainFactory: any MainFactory
    private let confirmationDialogFactory: any ConfirmationDialogFactory
    private let rootVC: UIViewController = {
        let launchScreenStoryboard = UIStoryboard(name: "LaunchScreen", bundle: .main)
        let launchScreen = launchScreenStoryboard.instantiateViewController(withIdentifier: "LaunchScreen")
        return launchScreen
    }()

    public var root: Presentable {
        rootVC
    }

    public init(
        window: UIWindow,
        splashFactory: any SplashFactory,
        signinFactory: any SigninFactory,
        mainFactory: any MainFactory,
        confirmationDialogFactory: any ConfirmationDialogFactory
    ) {
        self.window = window
        self.splashFactory = splashFactory
        self.signinFactory = signinFactory
        self.mainFactory = mainFactory
        self.window.makeKeyAndVisible()
        self.confirmationDialogFactory = confirmationDialogFactory
    }

    public func route(to path: RoutePath) -> MoordinatorContributors {
        guard let path = path.asDotori else { return .none }
        switch path {
        case .splash:
            let splashViewController = splashFactory.makeViewController()
            self.setRootViewController(viewController: splashViewController)
            return .one(
                .contribute(
                    withNextPresentable: splashViewController,
                    withNextRouter: splashViewController.store
                )
            )

        case .signin:
            let signinMoordinator = signinFactory.makeMoordinator()
            Moord.use(signinMoordinator) { root in
                self.setRootViewController(viewController: root)
            }
            return .one(
                .contribute(
                    withNextPresentable: signinMoordinator,
                    withNextRouter: DisposableRouter(singlePath: DotoriRoutePath.signin)
                )
            )

        case .main:
            let mainMoordinator = mainFactory.makeMoordinator()
            Moord.use(mainMoordinator) { root in
                self.setRootViewController(viewController: root)
            }
            return .one(
                .contribute(
                    withNextPresentable: mainMoordinator,
                    withNextRouter: DisposableRouter(singlePath: DotoriRoutePath.main)
                )
            )

        case let .confirmationDialog(title, description, confirmAction):
            let viewController = confirmationDialogFactory.makeViewController(
                title: title,
                description: description,
                confirmAction: confirmAction
            )
            self.window.rootViewController?.modalPresent(viewController)
            return .one(
                .contribute(
                    withNextPresentable: viewController,
                    withNextRouter: viewController.store
                )
            )

        case .dismiss:
            self.window.rootViewController?.presentedViewController?.dismiss(animated: true)

        default:
            return .none
        }
        return .none
    }
}

private extension RootMoordinator {
    func setRootViewController(viewController: UIViewController) {
        UIView.transition(
            with: self.window,
            duration: 0.3,
            options: .transitionCrossDissolve
        ) {
            self.window.rootViewController = viewController
        }
    }
}
