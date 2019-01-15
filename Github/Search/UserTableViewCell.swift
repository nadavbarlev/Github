//
//  UserTableViewCell.swift
//  Github
//
//  Created by Nadav Bar Lev on 13/01/2019.
//  Copyright © 2019 Nadav Bar Lev. All rights reserved.
//

import RxSwift
import RxCocoa

class UserTableViewCell: UITableViewCell {

    // MARK: Properties
    var disposeBag: DisposeBag?
    var viewModel: UserTableViewCellVM? {
        didSet {
            
            let disposeBag = DisposeBag()
            
            labelUsername.text = viewModel?.username
            viewModel?.image
                .bind(to: imageViewAvatar.rx.image)
                .disposed(by: disposeBag)
            
            self.disposeBag = disposeBag
        }
    }
    
    // MARK: LifeCycle
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.disposeBag = nil
        self.viewModel  = nil
    }
    
    // MARK: Outlets
    @IBOutlet weak var imageViewAvatar: UIImageView!
    @IBOutlet weak var labelUsername: UILabel!
    
    // MARK: LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
