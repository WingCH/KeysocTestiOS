//
//  BookmarkViewController.swift
//  KeysocCodingTest
//
//  Created by Wing on 1/3/2022.
//

import RxCocoa
import RxSwift
import UIKit

class BookmarkViewController: UIViewController {
    @IBOutlet var tableView: UITableView!

    let disposeBag = DisposeBag()
    let viewModel: BookmarkViewModel

    init(viewModel: BookmarkViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "BookmarkViewController", bundle: Bundle(for: BookmarkViewModel.self))
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
        self.title = "Albums"
        setTableView()
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

    private func bindViewModel() {
        
        viewModel.albumCellModels.asDriver(onErrorJustReturn: [])
            .drive(tableView.rx.items(cellIdentifier: "albumCell", cellType: AlbumCell.self)) { _, model, cell in
                cell.configure(model: model)
                cell.collectionPriceButton.rx.tap.asDriver()
                    .drive { [weak self] in
                        self?.viewModel.onUnBookMark(cellModel: model)
                    } onCompleted: {
                        print("collectionPriceButton onCompleted")
                    } onDisposed: {
                        print("collectionPriceButton onDisposed")
                    }.disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)
    }
}

extension BookmarkViewController: UITableViewDelegate {
    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return 80
    }
}
