//
//  WATopView.swift
//  Preplsy
//
//  Created by Waqas Ali on 7/26/16.
//  Copyright © 2016 dinosoftlabs. All rights reserved.
//

import UIKit
import SWRevealViewController

@objc protocol TopViewDelegate {
    func openMenu(_ sender:UIButton)
    @objc optional func editDoneButtonAction(_ sender:UIButton)
}

@IBDesignable class WATopView: UIView {
    
    //MARK:- IBOutlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var done: UIButton!
    @IBOutlet weak var doneHeight: NSLayoutConstraint!
    @IBOutlet weak var doneWidth: NSLayoutConstraint!
    
    var delegate: TopViewDelegate?
    
    var nibName = "WATopView"
    var view: UIView!
    
    @IBInspectable var doneText: String = "" {
        didSet {
            self.done.setTitle(doneText, for: UIControlState())
        }
    }

    @IBInspectable var doneImage: String = "" {
        didSet {
            self.done.setImage(UIImage(named:doneImage), for: .normal)
        }
    }
    
    @IBInspectable var doneHeightConstraint: CGFloat = 0.0 {
        didSet {
            self.doneHeight.constant = doneHeightConstraint
        }
    }
    
    @IBInspectable var doneWidthConstraint: CGFloat = 0.0 {
        didSet {
            self.doneWidth.constant = doneWidthConstraint
        }
    }
    
    @IBInspectable var backGroundColors: UIColor = UIColor.clear {
        didSet {
            self.view.layer.backgroundColor = backGroundColors.cgColor
        }
    }
    
    @IBInspectable var labelText: String = "" {
        didSet {
            self.nameLabel.text = labelText
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        xibSetup()
    }
    
    func xibSetup() {
        view = loadViewFromXib()
        view.frame = self.bounds
        view.autoresizingMask = [UIViewAutoresizing.flexibleHeight , UIViewAutoresizing.flexibleWidth]
        addSubview(view)
    }
    
    func loadViewFromXib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName , bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        return view
    }
    
    
    //MARK:- IBActions
    
    @IBAction func menuButtonAction(_ sender: UIButton) {
        delegate?.openMenu(sender)
    }
    
    @IBAction func doneButtonAction(_ sender:UIButton) {
        delegate?.editDoneButtonAction!(sender)
    }
}
