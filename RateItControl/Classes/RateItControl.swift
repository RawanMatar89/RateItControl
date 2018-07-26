//
//  RateItControl.swift
//  RateItControl
//
//  Created by Rawan Marzouq on 7/26/18.
//

import Foundation
import UIKit

@available(iOS 9.0, *)
@IBDesignable public class RatingControl: UIStackView{
    
    //MARK: Inspectable Properties
    @IBInspectable public var elementsCount : Int = 5{
        didSet{
            setupElements()
        }
    }
    @IBInspectable public var rating : Int = 3{
        didSet{
            updateButtonSelectionStates()
        }
    }
    @IBInspectable public var filledImage : UIImage?{
        didSet{
            setupElements()
        }
    }
    @IBInspectable public var emptyImage : UIImage?{
        didSet{
            setupElements()
        }
    }
    @IBInspectable public var elementSize : CGSize = CGSize(width: 44.0, height: 44.0){
        didSet{
            setupElements()
        }
    }
    //MARK: Properties
    public var ratingElements = [UIButton]()
    
    //MARK: Initialization
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        // Check element image
        checkImages()
        
        // Setup elements
        setupElements()
    }
    required public init(coder: NSCoder) {
        super.init(coder:coder)
        
        // Check element image
        checkImages()
        
        // Setup elements
        setupElements()
    }
    
    public func checkImages(){
        let bundle = Bundle(for: type(of: self))
        if filledImage == nil {
            filledImage = UIImage(named: "Filled", in: bundle, compatibleWith: self.traitCollection)
        }
        if emptyImage == nil {
            emptyImage = UIImage(named: "Empty", in: bundle, compatibleWith: self.traitCollection)
        }
    }
    //MARK: Create rating elements
    private func setupElements(){
        
        // Clear all existing buttons
        for button in ratingElements{
            removeArrangedSubview(button)
            button.removeFromSuperview()
        }
        ratingElements.removeAll()
        
        // Create new buttons
        for i in 0..<elementsCount {
            
            // Create button
            let button = UIButton()
            button.tag = i
            
            // Add constraint
            button.translatesAutoresizingMaskIntoConstraints = false
            button.heightAnchor.constraint(equalToConstant: elementSize.height).isActive = true
            button.widthAnchor.constraint(equalToConstant: elementSize.width).isActive = true
            
            
            // Set button image
            button.setImage(emptyImage, for: .normal)
            button.setImage(filledImage, for: .highlighted)
            button.setImage(filledImage, for: .selected)
            
            // Setup button action
            button.addTarget(self, action: #selector(RatingControl.ratingButtonTapped(button:)), for: .touchUpInside)
            
            // Add button to the stack view
            addArrangedSubview(button)
            
            // Add button to rating elements array
            ratingElements.append(button)
        }
        updateButtonSelectionStates()
    }
    
    //MARK: Button actions
    @objc func ratingButtonTapped(button: UIButton){
        print(button.tag)
        guard let index = ratingElements.index(of: button)else{
            fatalError("The button, \(button), is not in the ratingElements array: \(ratingElements)")
        }
        let selectedRating = index + 1
        if selectedRating == rating {
            rating = 0
        }
        else{
            rating = selectedRating
        }
        
    }
    
    private func updateButtonSelectionStates(){
        for (index, button) in ratingElements.enumerated() {
            button.isSelected = index < rating
        }
    }
}
