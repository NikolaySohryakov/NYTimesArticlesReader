//
//  Created by Nikolay Sohryakov on 27/02/2018.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    fileprivate var coordinator: SceneCoordinatorType?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        guard let uWindow = window else {
            fatalError("Unable to create application window")
        }
        
        coordinator = AppCoordinator(window: uWindow)
        let service = ArticlesSearchService(token: "a72c379ecf4d4a60a7f2c0194964bd23")
        let viewModel = MainViewModel(coordinator: coordinator!, service: service)
        let scene = MainScene(viewModel: viewModel)
        
        coordinator?.transition(to: scene, type: .root)
        
        return true
    }
}

