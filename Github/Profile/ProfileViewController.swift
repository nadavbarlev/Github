//
//  ProfileViewController.swift
//  Github
//
//  Created by Nadav Bar Lev on 13/01/2019.
//  Copyright © 2019 Nadav Bar Lev. All rights reserved.
//

import RxSwift
import RxCocoa

class ProfileViewController: UIViewController {

    // MARK: Properties
    let disposeBag = DisposeBag()
    var viewModel: ProtocolProfileViewControllerVM!
    
    // MARK: Outlets
    @IBOutlet weak var imageViewAvatar: RoundableImageView!
    @IBOutlet weak var labelUsername: UILabel!
    @IBOutlet weak var buttonShowComments: UIButton!
    
    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        labelUsername.text = viewModel.username
        
        viewModel.image
            .bind(to: imageViewAvatar.rx.image)
            .disposed(by: disposeBag)
        
        buttonShowComments.rx.tap
            .bind(to: viewModel.showCommentsDidTap)
            .disposed(by: disposeBag)
        
        viewModel.presentCommentVC
            .subscribe(onNext: { [weak self] (commentViewControllerVM: ProtocolCommentsViewControllerVM) in
                let commentVC = self?.storyboard?.instantiateViewController(withIdentifier: "CommentsViewController")
                        as! CommentsViewController
                commentVC.viewModel = commentViewControllerVM
                self?.navigationController?.show(commentVC, sender: nil)
            }).disposed(by: disposeBag)
    }
}
