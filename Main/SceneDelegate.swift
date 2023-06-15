import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {

        guard let windowScene = (scene as? UIWindowScene) else { return }

        let remoteAddAccount = UseCaseFactory.makeRemoteAddAccount()
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = SignUpComposer.composeController(with: remoteAddAccount)
        window?.makeKeyAndVisible()
    }
}
