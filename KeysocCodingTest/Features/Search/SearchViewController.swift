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
    var viewModel: SearchViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()

        setSearchBar()
        setTableView()

        viewModel = SearchViewModel(
            searchText: searchController!.searchBar.rx.text.orEmpty.asDriver().throttle(.milliseconds(300)), dependency: (networkManager: NetworkManager(requestTimeOut: 30), bookmarkRepository: LocalBookmarkRepository())
        )

        viewModel!.albumCellModels.asDriver(onErrorJustReturn: [])
            .drive(tableView.rx.items(cellIdentifier: "albumCell", cellType: AlbumCell.self)) { _, model, cell in
                cell.configure(model: model)
                cell.collectionPriceButton.rx.tap.asDriver()
                    .drive { [weak self] in
                        self?.viewModel?.onBookedMarkAlbum(cellModel: model)
                    } onCompleted: {
                        print("collectionPriceButton onCompleted")
                    } onDisposed: {
                        print("collectionPriceButton onDisposed")
                    }.disposed(by: cell.disposeBag)
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

        tableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                print(indexPath)
            }).disposed(by: disposeBag)
    }
}

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
