import Google
import GoogleSignIn
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    private let window = UIWindow(frame: UIScreen.main.bounds)
    let flowcontroller = FlowController(navigationController: UINavigationController())
    var saved: UserDefaults?
    

    func applicationDidFinishLaunching(_ application: UIApplication) {
        // Initialize sign-in
        
        window.makeKeyAndVisible()
        window.rootViewController = flowcontroller.nc
        flowcontroller.start()
        saved = UserDefaults.standard
        var configureError: NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)
        assert(configureError == nil, "Error configuring Google services: \(String(describing: configureError))")
    }
    
    func application(_ application: UIApplication,
                     open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return GIDSignIn.sharedInstance().handle(url,
                                                 sourceApplication: sourceApplication,
                                                 annotation: annotation)
    }
    
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
//        saved?.set(flowcontroller.dayAsString, forKey: "day")
//        saved?.set(flowcontroller.name, forKey: "name")
//        saved?.synchronize()
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
//        saved?.set(flowcontroller.dayAsString, forKey: "day")
//        saved?.set(flowcontroller.name, forKey: "name")
//        saved?.synchronize()
    }

    
    @available(iOS 9.0, *)
    func application(_ app: UIApplication, open url: URL,
                     options: [UIApplicationOpenURLOptionsKey : Any]) -> Bool {
        let sourceApplication = options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String
        let annotation = options[UIApplicationOpenURLOptionsKey.annotation]
        return GIDSignIn.sharedInstance().handle(url,
                                                 sourceApplication: sourceApplication,
                                                 annotation: annotation)
    }
    
    
}


