//
//  AppDelegate.swift
//  KeysocCodingTest
//
//  Created by Wing on 1/3/2022.
//

import Moya
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)

        // MARK: Dependency
        let itunesRepository: ItunesRepository = RemoteItunesRepository(
            provider: MoyaProvider<ItunesAPI>()
        )
        let bookmarkRepository = LocalBookmarkRepository()

        // MARK: Root tabbar
        let tabBarController = UITabBarController()

        // MARK: Setup SearchView
        let searchViewModel = SearchViewModel(
            dependency: (
                itunesRepository: itunesRepository,
                bookmarkRepository: bookmarkRepository
            )
        )
        let searchTabNavigationController = UINavigationController(
            rootViewController: SearchViewController(viewModel: searchViewModel)
        )

        let searchTabItem = UITabBarItem(
            title: "Search",
            image: UIImage(named: "search"),
            tag: 0
        )
        searchTabNavigationController.tabBarItem = searchTabItem

        // MARK: Setup BookmarkView
        let bookmarkViewModel = BookmarkViewModel(
            bookmarkRepository: bookmarkRepository
        )

        let bookmarkTabNavigationController = UINavigationController(
            rootViewController: BookmarkViewController(viewModel: bookmarkViewModel)
        )
        let bookmarkTabItem = UITabBarItem(
            title: "Bookmark",
            image: UIImage(named: "bookmark"),
            tag: 0
        )
        bookmarkTabNavigationController.tabBarItem = bookmarkTabItem

        // MARK: Add search and bookmark page to tabbar
        tabBarController.viewControllers = [
            searchTabNavigationController,
            bookmarkTabNavigationController,
        ]

        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
        return true
    }
}
