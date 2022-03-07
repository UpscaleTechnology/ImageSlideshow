//
//  PageIndicator.swift
//  ImageSlideshow
//
//  Created by Petr Zvoníček on 27.05.18.
//

import UIKit

/// Cusotm Page Indicator can be used by implementing this protocol
public protocol PageIndicatorView: AnyObject {
    /// View of the page indicator
    var view: UIView { get }
    
    /// Current page of the page indicator
    var page: Int { get set }
    
    /// Total number of pages of the page indicator
    var numberOfPages: Int { get set}
    
}

extension UIPageControl: PageIndicatorView {
    
    public var view: UIView {
        return self
    }
    
    public var page: Int {
        get {
            return currentPage
        }
        set {
            currentPage = newValue
        }
    }
    
    open override func sizeToFit() {
        var frame = self.frame
        frame.size = size(forNumberOfPages: numberOfPages)
        frame.size.height = 30
        self.frame = frame
    }
    
    public static func withSlideshowColors() -> UIPageControl {
        let pageControl = UIPageControl()
        
        if #available(iOS 13.0, *) {
            pageControl.currentPageIndicatorTintColor = UIColor { traits in
                traits.userInterfaceStyle == .dark ? .white : .lightGray
            }
        } else {
            pageControl.currentPageIndicatorTintColor = .lightGray
        }
        
        if #available(iOS 13.0, *) {
            pageControl.pageIndicatorTintColor = UIColor { traits in
                traits.userInterfaceStyle == .dark ? .systemGray : .black
            }
        } else {
            pageControl.pageIndicatorTintColor = .black
        }
        
        return pageControl
    }
}

/// Page indicator that shows page in numeric style, eg. "5/21"
public class LabelPageIndicator: UILabel, PageIndicatorView {
    public var view: UIView {
        return self
    }
    
    public var numberOfPages: Int = 0 {
        didSet {
            updateLabel()
        }
    }
    
    public var page: Int = 0 {
        didSet {
            updateLabel()
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    private func initialize() {
        self.textAlignment = .center
    }
    
    private func updateLabel() {
        text = "\(page+1)/\(numberOfPages)"
    }
    
    public override func sizeToFit() {
        let maximumString = String(repeating: "8", count: numberOfPages) as NSString
        self.frame.size = maximumString.size(withAttributes: [.font: font as Any])
    }
}

public class ViewPageIndicator: UIStackView, PageIndicatorView {
    
    public var view: UIView {
        return self
    }
    
    public var numberOfPages: Int = 0 {
        didSet {
            updateLabel()
        }
    }
    
    public var page: Int = 0 {
        didSet {
            updateLabel()
        }
    }
    
    public override func sizeToFit() {
        let widthOfString = "\(numberOfPages)/\(numberOfPages)".widthOfString(usingFont: UIFont.boldSystemFont(ofSize: 15))
        var frame = self.frame
        frame.size.width = 70 + widthOfString
        frame.size.height = 30
        self.frame = frame
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }
    
    var nextButton: UIButton = {
        let button = UIButton()
        let icon = UIImage(named: "fi_chevron-right", in: .module, compatibleWith: nil)
        button.setImage(icon, for: .normal)
        button.setTitle("", for: .normal)
        button.tintColor = .white
        return button
    }()
    
    var backButton: UIButton = {
        let button = UIButton()
        
        let icon = UIImage(named: "fi_chevron-left", in: .module, compatibleWith: nil)
        button.setImage(icon, for: .normal)
        button.setTitle("", for: .normal)
        button.tintColor = .white
        return button
    }()
    
    var currentPageLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .white
        label.text = "-/-"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 15)
        return label
    }()
    
    private func initialize() {
        
        self.layer.cornerRadius = 4
        self.clipsToBounds = true
        
        self.axis = .horizontal
        self.spacing = 0
        self.backgroundColor = .black.withAlphaComponent(0.2)
        
        self.addArrangedSubview(backButton)
        NSLayoutConstraint(item: backButton, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 30).isActive = true
        
        self.addArrangedSubview(currentPageLabel)
        
        self.addArrangedSubview(nextButton)
        NSLayoutConstraint(item: nextButton, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 30).isActive = true
        
        self.layoutIfNeeded()
    }
    
    private func updateLabel() {
        currentPageLabel.text = "\(page + 1)/\(numberOfPages)"
    }
}

public class LabelPageDescription: UILabel, PageIndicatorView {
    
    public var itemDescription: String = "" {
        didSet {
            updateLabel()
        }
    }
    
    public var view: UIView {
        return self
    }
    
    public var numberOfPages: Int = 0 {
        didSet {
            updateLabel()
        }
    }
    
    public var page: Int = 0 {
        didSet {
            updateLabel()
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    private func initialize() {
        self.textAlignment = .right
        textColor = .white
    }
    
    private func updateLabel() {
        font = UIFont.boldSystemFont(ofSize: 14)
        text = itemDescription
    }
}

extension String {
  func widthOfString(usingFont font: UIFont) -> CGFloat {
    let fontAttributes = [NSAttributedString.Key.font: font]
    let size = self.size(withAttributes: fontAttributes)
    return size.width
  }
}
