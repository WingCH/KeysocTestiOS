//
//  SearchViewController.swift
//  KeysocCodingTest
//
//  Created by Wing on 1/3/2022.
//

import UIKit

class SearchViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
    private var searchController: UISearchController?

    override func viewDidLoad() {
        super.viewDidLoad()
        setSearchBar()
    }

    private func setSearchBar() {
        searchController = UISearchController(searchResultsController: nil)
        searchController?.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
    }

    /*
     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destination.
         // Pass the selected object to the new view controller.
     }
     */
}

extension SearchViewController: UITableViewDelegate {}
