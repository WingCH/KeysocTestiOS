//
//  SearchViewController.swift
//  KeysocCodingTest
//
//  Created by Wing on 1/3/2022.
//

import RxCocoa
import RxSwift
import UIKit

class SearchViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
    private var searchController: UISearchController?

    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        setSearchBar()
        setTableView()

        let viewModel = SearchViewModel(
            searchText: searchController!.searchBar.rx.text.orEmpty.asDriver().throttle(.milliseconds(300))
        )

        viewModel.albums.asDriver(onErrorJustReturn: [])
            .drive(tableView.rx.items(cellIdentifier: "albumCell", cellType: AlbumCell.self)) { _, value, cell in
                cell.collectionNameLabel.text = value
                cell.setImage(
                    imageUrl: "https://is1-ssl.mzstatic.com/image/thumb/Music124/v4/09/61/22/0961224e-34b2-87c5-188b-7a87ac90cf62/source/100x100bb.jpg"
                )
            }
            .disposed(by: disposeBag)
    }

    private func setSearchBar() {
        searchController = UISearchController(searchResultsController: nil)
        searchController?.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
    }

    private func setTableView() {
        tableView.register(UINib(nibName: "AlbumCell", bundle: nil), forCellReuseIdentifier: "albumCell")
        tableView
            .rx.setDelegate(self)
            .disposed(by: disposeBag)
    }

    private func binding() {
//        let searchResults: Observable<[String]>? = searchController?.searchBar.rx.text.orEmpty
//            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
//            .distinctUntilChanged()
//            .flatMapLatest { query -> Observable<[String]> in
//                if query.isEmpty {
//                    return .just([])
//                }
        ////                return searchGitHub(query)
        ////                    .catchAndReturn([])
//
//                return Observable.just([
//                    "文本输入框的用法",
//                    "开关按钮的用法",
//                    "进度条的用法",
//                    "文本标签的用法",
//                ])
//            }
//            .observe(on: MainScheduler.instance)
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

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
