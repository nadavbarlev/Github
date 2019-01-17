//
//  ViewController.swift
//  Github
//
//  Created by Nadav Bar Lev on 09/01/2019.
//  Copyright © 2019 Nadav Bar Lev. All rights reserved.
//

import RxSwift
import RxCocoa
import RxOptional

class SearchViewController: UIViewController {

    // MARK: Properties
    var viewModel: ProtocolSearchViewControllerVM!
    let disposeBag = DisposeBag()
    
    // MARK: Outlets
    @IBOutlet weak var labelCount: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableViewUsers: UITableView!
    
    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Binding Configuration
        tableViewUsers.rx.itemSelected
            .map { $0.row }
            .bind(to: viewModel.cellDidSelect)
            .disposed(by: disposeBag)
        
        searchBar.rx.text.orEmpty
            .bind(to: viewModel.searchText)
            .disposed(by: disposeBag)
        
        viewModel.resultCount
            .bind(to: labelCount.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.cellsModel
            .bind(to: tableViewUsers.rx.items(cellIdentifier: "UserTableViewCell", cellType: UserTableViewCell.self)) {
                (index, cellModel, cell) in
                cell.viewModel = cellModel
            }.disposed(by: disposeBag)
        
        viewModel.presentProfileVC
            .subscribe(onNext: { (profileViewControllerVM: ProtocolProfileViewControllerVM) in
                let profileVC = self.storyboard?.instantiateViewController(withIdentifier: "ProfileViewController")
                                    as! ProfileViewController
                profileVC.viewModel = profileViewControllerVM
                self.navigationController?.pushViewController(profileVC, animated: true)
            }).disposed(by: disposeBag)
        
        tableViewUsers.rx.contentOffset
            .subscribe(onNext: { [weak self] _ in
                guard let isFirstResponder = self?.searchBar.isFirstResponder,
                    isFirstResponder == true else { return }
                    self?.searchBar.resignFirstResponder()
            }).disposed(by: disposeBag)
        
    }
}
