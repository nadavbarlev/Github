//
//  AppDelegate.swift
//  Github
//
//  Created by Nadav Bar Lev on 09/01/2019.
//  Copyright © 2019 Nadav Bar Lev. All rights reserved.
//

import UIKit
import Firebase
import Swinject
import SwinjectStoryboard

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    // MARK: Properties
    var window: UIWindow?
    var container: Container!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Swinject - Registrations
        container = Container { (container: Container) in
            
            // Models
            container.register(ProtocolGithubService.self) { resolver in
                GithubService()
            }
            
            container.register(ProtocolCommentService.self) { resolver in
                CommentService()
            }
            
            // View-Models
            container.register(ProtocolSearchViewControllerVM.self) { resolver in
                SearchViewControllerVM(githubService: resolver.resolve(ProtocolGithubService.self)!,
                                      commentService: resolver.resolve(ProtocolCommentService.self)!)
            }
            
            // Views
            container.storyboardInitCompleted(UINavigationController.self) { _, _ in }
            container.storyboardInitCompleted(ProfileViewController.self) { _, _ in }
            container.storyboardInitCompleted(CommentsViewController.self) { _, _ in }
            container.storyboardInitCompleted(SearchViewController.self) { resolver, controller in
                controller.viewModel = resolver.resolve(ProtocolSearchViewControllerVM.self)!
            }
        }
        
        // Swinject - Create Swinject Storyboard
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .white
        window?.makeKeyAndVisible()
        let storyboard = SwinjectStoryboard.create(name: "Main",
                                                 bundle: Bundle(for: SearchViewController.self),
                                              container: container)
        window?.rootViewController = storyboard.instantiateInitialViewController()
        
        // Firebase - Configuration
        FirebaseApp.configure()
       
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

