import ConfirmationDialogFeature
import MainTabFeature
import SigninFeature
import SplashFeature
import Swinject

public final class RootAssembly: Assembly {
    public init() {}
    public func assemble(container: Container) {
        container.register(RootMoordinator.self) { resolver, window in
            RootMoordinator(
                window: window,
                splashFactory: resolver.resolve(SplashFactory.self)!,
                signinFactory: resolver.resolve(SigninFactory.self)!,
                mainFactory: resolver.resolve(MainFactory.self)!,
                confirmationDialogFactory: resolver.resolve(ConfirmationDialogFactory.self)!
            )
        }
    }
}
