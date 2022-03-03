//
//  AppDelegate.swift
//  KeysocCodingTest
//
//  Created by Wing on 1/3/2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)

        // MARK: Dependency

        let networkManager = NetworkManager(requestTimeOut: 30)
        let bookmarkRepository = LocalBookmarkRepository()

        let tabBarController = UITabBarController()

        let searchViewModel = SearchViewModel(
            dependency: (
                networkManager: networkManager,
                bookmarkRepository: bookmarkRepository
            )
        )
        let searchTabNavigationController = UINavigationController(
            rootViewController: SearchViewController(viewModel: searchViewModel)
        )

        let searchTabItem = UITabBarItem(title: "Search", image: UIImage(named: "search"), tag: 0)
        searchTabNavigationController.tabBarItem = searchTabItem

        let bookmarkTabNavigationController = UINavigationController(rootViewController: BookmarkViewController())
        let bookmarkTabItem = UITabBarItem(title: "Bookmark", image: UIImage(named: "bookmark"), tag: 0)
        bookmarkTabNavigationController.tabBarItem = bookmarkTabItem

        tabBarController.viewControllers = [searchTabNavigationController, bookmarkTabNavigationController]

        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
        return true
    }
}
