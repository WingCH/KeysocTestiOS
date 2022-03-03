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
    @IBOutlet var emptyView: UIStackView!
    @IBOutlet var exampleButton: UIButton!

    let disposeBag = DisposeBag()
    let viewModel: SearchViewModel

    init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "SearchViewController", bundle: Bundle(for: SearchViewController.self))
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        bindViewModel()
    }

    private func configUI() {
        setSearchBar()
        setTableView()
    }

    private func bindViewModel() {
        // MARK: bind searchBar bind
        viewModel.searchBarTextObserver
            .bind(to: searchController!.searchBar.rx.text)
            .disposed(by: disposeBag)

        searchController?.searchBar.rx.text.orEmpty.asDriver().throttle(.microseconds(500))
            .drive(viewModel.searchBarTextObserver)
            .disposed(by: disposeBag)

        // MARK: bind tableview
        viewModel.albumCellModels.asDriver(onErrorJustReturn: [])
            .drive(tableView.rx.items(cellIdentifier: "albumCell", cellType: AlbumCell.self)) { _, model, cell in
                cell.configure(model: model)
                cell.collectionPriceButton.rx.tap.asDriver()
                    .drive(onNext: { [weak self] _ in
                        self?.viewModel.onBookedMarkAlbum(cellModel: model)
                    }).disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)

        // MARK: if no data show emptyView
        viewModel.albumCellModels.asDriver(onErrorJustReturn: [])
            .map { $0.count != 0 }
            .drive(emptyView.rx.isHidden)
            .disposed(by: disposeBag)

        exampleButton.rx.tap.asDriver().drive { [weak self] _ in
            if let exampleSearchKey = self?.exampleButton.titleLabel?.text {
                self?.viewModel.onClickExampleButton(searchKey: exampleSearchKey)
            }
        }.disposed(by: disposeBag)
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
}

extension SearchViewController: UITableViewDelegate {
    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return 80
    }
}
