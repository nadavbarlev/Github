//
//  RoundableImageView.swift
//  Github
//
//  Created by Nadav Bar Lev on 14/01/2019.
//  Copyright © 2019 Nadav Bar Lev. All rights reserved.
//

import UIKit

@IBDesignable
class RoundableImageView: UIImageView {

    // MARK: Designable
    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet { setNeedsLayout() }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.clear {
        didSet { setNeedsLayout() }
    }
    
    @IBInspectable var borderWidth: Double = 0 {
        didSet { setNeedsLayout() }
    }
    
    @IBInspectable var isCircular: Bool = false {
        didSet { setNeedsLayout() }
    }
    
    // MARK: Computed Properties
    var corner: CGFloat {
        return isCircular ? (self.bounds.size.height / 2) : cornerRadius
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius  = corner
        self.layer.masksToBounds = true
        self.layer.borderColor   = borderColor.cgColor
        self.layer.borderWidth   = CGFloat(borderWidth)
    }
}
