//
//  RatingControl.swift
//  ShoppingList
//
//  Created by zero on 2020/11/14.
//

import UIKit

@IBDesignable class RatingControl: UIStackView {
    
    var ratingButtons = [UIButton]()
    
    var rating = 0 {
        didSet {
            updateButtonStates()
        }
    }
    
    @IBInspectable var starSideLength : CGFloat = 48.0 {
        didSet {
            setupButtons()
        }
    }
    
    
    private func setupButtons() {
        for btn in ratingButtons {
            removeArrangedSubview(btn)
            btn.removeFromSuperview()
        }
        ratingButtons.removeAll()
        
        let emptyStarImage = UIImage(named: "emptyStar")
        let filledStarImage = UIImage(named: "filledStar")
        for _ in 0..<5 {
            let btn = UIButton()
            btn.setImage(emptyStarImage, for: .normal)
            btn.setImage(filledStarImage, for: .selected)
            btn.setImage(emptyStarImage, for: .highlighted)
            btn.setImage(filledStarImage, for: [.selected, .highlighted])
            btn.contentVerticalAlignment = .fill
            btn.contentHorizontalAlignment = .fill
            btn.translatesAutoresizingMaskIntoConstraints = false
            btn.widthAnchor.constraint(equalToConstant: starSideLength).isActive = true
            btn.heightAnchor.constraint(equalTo: btn.widthAnchor, multiplier: 1.0).isActive = true
            btn.addTarget(self, action: #selector(ratingButtonTouched), for: .touchUpInside)
            self.addArrangedSubview(btn)
            ratingButtons.append(btn)
        }
        updateButtonStates()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButtons()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupButtons()
    }
    

    @objc private func ratingButtonTouched(_ button : UIButton) {
        guard let idx = ratingButtons.firstIndex(of: button) else {
            fatalError("The button, \(button), is not in the ratingButtons array: \(ratingButtons)")
        }
        if rating == idx + 1 {
            rating = 0
        } else {
            rating = idx + 1
        }
    }
    
    private func updateButtonStates() {
        for (idx, btn) in ratingButtons.enumerated() {
            btn.isSelected = (idx + 1 <= rating)
        }
    }
}
