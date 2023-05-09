import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)

        let vc = HomeVC()
        
        let model = WeightsStore()
        let viewModel = WeightsViewModel(model: model)
        vc.initialize(viewModel: viewModel)

        window.rootViewController = vc
        window.makeKeyAndVisible()
        self.window = window
    }

}

