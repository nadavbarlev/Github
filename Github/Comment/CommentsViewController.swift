//
//  CommentsViewController.swift
//  Github
//
//  Created by Nadav Bar Lev on 13/01/2019.
//  Copyright © 2019 Nadav Bar Lev. All rights reserved.
//

import RxSwift
import RxCocoa
import RxOptional

class CommentsViewController: UIViewController {

    // MARK: Properties
    let disposeBag = DisposeBag()
     var viewModel: ProtocolCommentsViewControllerVM!
    
    // MARK: Outlets
    @IBOutlet weak var tableViewComments: UITableView!
    @IBOutlet weak var buttonSubmit: UIButton!
    @IBOutlet weak var textFieldComment: UITextField!
    
    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
       buttonSubmit.rx.tap
            .bind(to: viewModel.submitDidTap)
            .disposed(by: disposeBag)
        
       textFieldComment.rx.text.orEmpty
            .bind(to: viewModel.textComment)
            .disposed(by: disposeBag)

        viewModel.submitEnabled
            .bind(to: buttonSubmit.rx.isEnabled)
            .disposed(by: disposeBag)
        
        viewModel.cellsModel
            .bind(to: tableViewComments.rx.items) { (tableView, row, element) in
                let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell")!
                cell.textLabel?.text = element
                return cell
            }.disposed(by: disposeBag)
        
        viewModel.clearText
            .subscribe(onNext: {
                self.textFieldComment.text = ""
            }).disposed(by: disposeBag)
        
        
        tableViewComments.rx.didScroll
            .subscribe(onNext: { [weak self] _ in
                self?.textFieldComment.resignFirstResponder()
            }).disposed(by: disposeBag)
        
    }
    
}
