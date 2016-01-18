//
//  CustomSegement.swift
//  CustomSegement
//
//  Created by luojie on 15/12/15.
//  Copyright © 2015年 LuoJie. All rights reserved.
//

import UIKit

// Todo:
// Font size
// sbWidth = 0 , sbHeight = 0, showSelectedBackgroundView = true

@IBDesignable

public class SegmentedControl: UIControl {
    
    private struct Constants {
        private struct SelectedBackgroundView{
            static let DefaultViewHeight: CGFloat = 0
            static let DefaultWidth: CGFloat = 50
            static let DefaultBackgroundColor = UIColor.darkGrayColor()
        }
        
        private struct Title {
            static let DefaultFontSize: CGFloat = 16
            static let DefalutColor = UIColor.darkGrayColor()
            static let DefalutHighlightedColor = UIColor.yellowColor()
            static let DefalutSelectedColor = UIColor.whiteColor()
        }
        
        private struct Segment {
            static let DefaultTitle = ""
            static let DefaultSegments: [SegmentTitleProvider] = ["Title1", "Title2"]
        }
        
    }
    
    // Background
    @IBInspectable public
    var sbvHeight: CGFloat = Constants.SelectedBackgroundView.DefaultViewHeight { didSet { updateSelectedBackgroundFrame() } }
    
    @IBInspectable public
    var sbColor: UIColor = Constants.SelectedBackgroundView.DefaultBackgroundColor { didSet { updateSelectedBackgroundColor() } }
    
    @IBInspectable public
    var sbWidth: CGFloat = Constants.SelectedBackgroundView.DefaultWidth { didSet { updateSelectedBackgroundFrame() } }
    
    // Title
    @IBInspectable public
    var fontSize: CGFloat = Constants.Title.DefaultFontSize { didSet { updateTitleStyle() } }
    
    @IBInspectable public
    var titleColor: UIColor = Constants.Title.DefalutColor { didSet { updateTitleStyle() } }
    
    @IBInspectable public
    var highlightedTC: UIColor = Constants.Title.DefalutHighlightedColor { didSet { updateTitleStyle() } }
    
    @IBInspectable public
    var selectedTC: UIColor = Constants.Title.DefalutSelectedColor { didSet { updateTitleStyle() } }
    
    // Segment
    @IBInspectable public
    var segmentTitle: String = Constants.Segment.DefaultTitle { didSet { updateSegments(titles: segmentTitle) } }
    
    public var segments: [SegmentTitleProvider] = Constants.Segment.DefaultSegments { didSet { updateSegments(titles: nil) } }
    
    public private(set) var segmentItems: [UIButton] = []
    
    // Selected
    @IBInspectable public
    var selectedIndex: Int = 0 {
        didSet {
            selectedIndex = segments.validIndexFor(selectedIndex)!
            if selectedIndex != oldValue { valueChanged = true }
            if selectedIndex < segmentItems.endIndex {
                updateSelectedIndex(animated: animationEnable)
            }
        }
    }
    
    private var valueChanged = false
    
    @IBInspectable public
    var animationEnable: Bool = true
    
    public let selectedBackgroundView = UIView()
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureElements()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureElements()
        
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        updateSegmentFrames()
        updateSelectedIndex(animated: false)
    }
    
    public func segmentTouched(sender: UIButton) {
        guard let index = segmentItems.indexOf(sender) else { return }
        selectedIndex = index
    }
    
    
}

// MARK: - Private methods
private extension SegmentedControl {
    func configureElements() {
        insertSubview(selectedBackgroundView, atIndex: 0)
        updateSegments(titles: nil)
    }
    
    func updateSegments(titles titles: String?) {
        if let titles = titles {
            let extractedTitles = titles.characters.split(100, allowEmptySlices: false, isSeparator: { $0 == "," }).map { String($0) }
            segments = extractedTitles.map { $0 }
            return
        }
        
        segmentItems.removeFromSuperview()
        segmentItems.removeAll(keepCapacity: true)
        
        // Reset data
        if segments.count > 0 {
            let itemWidth: CGFloat = frame.width / CGFloat(segments.count)
            for (index, segment) in segments.enumerate() {
                let item = UIButton(frame: CGRect(
                    x: itemWidth * CGFloat(index),
                    y: 0,
                    width: itemWidth,
                    height: frame.height)
                )
                
                item.selected = (index == selectedIndex)
                item.setTitle(segment.segmentTitle, forState: .Normal)
                item.addTarget(self, action: "segmentTouched:", forControlEvents: .TouchUpInside)
                
                addSubview(item)
                segmentItems.append(item)
            }
        }
        
        updateTitleStyle()
        updateSelectedIndex(animated: false)
    }
    
    func updateSegmentFrames() {
        guard segments.count > 0 else { return }
        let itemWidth: CGFloat = frame.width / CGFloat(segments.count)
        for (index, item) in segmentItems.enumerate() {
            item.frame = CGRect(
                x: itemWidth * CGFloat(index),
                y: 0,
                width: itemWidth,
                height: frame.height
            )
        }
    }
    
    func updateTitleStyle() {
        segmentItems.forEach {
            item in
            item.setTitleColor(titleColor, forState: .Normal)
            item.setTitleColor(highlightedTC, forState: .Highlighted)
            item.setTitleColor(selectedTC, forState: .Selected)
            item.titleLabel?.font = UIFont.systemFontOfSize(fontSize)
        }
    }
    
    func updateSelectedIndex(animated animated: Bool) {
        segmentItems.forEach { $0.selected = false }
        if valueChanged {
            valueChanged = false
            sendActionsForControlEvents(.ValueChanged)
        }
        if animated {
            UIView.animateWithDuration(0.3,
                delay: 0,
                usingSpringWithDamping: 0.7,
                initialSpringVelocity: 0.3,
                options: .CurveEaseOut,
                animations: {
                    self.updateSelectedBackgroundFrame()
                },
                completion: {
                    _ in
                    self.segmentItems[self.selectedIndex].selected = true
                }
            )
        } else {
            updateSelectedBackgroundFrame()
            segmentItems[selectedIndex].selected = true
        }
        
    }
    
    func updateSelectedBackgroundColor() {
        selectedBackgroundView.backgroundColor = sbColor
    }
    
    func updateSelectedBackgroundFrame() {
        guard selectedIndex < segmentItems.count else { return }
        let segment = segmentItems[selectedIndex]
        var frame = segment.frame
        frame.size.height = sbvHeight > 0 ? sbvHeight : self.frame.height
        frame.origin.y = sbvHeight > 0 ? self.frame.height - sbvHeight : 0
        let sbWidthInset = (frame.size.width - sbWidth) / 2
        selectedBackgroundView.frame = UIEdgeInsetsInsetRect(frame, UIEdgeInsetsMake(0, sbWidthInset, 0, sbWidthInset))
    }
}

// MARK: - DAta types, Protocol & Extensions
public protocol SegmentTitleProvider {
    var segmentTitle: String { get }
}

extension String: SegmentTitleProvider {
    public var segmentTitle: String {
        return self
    }
}

extension UIViewController: SegmentTitleProvider {
    public var segmentTitle: String {
        return title ?? ""
    }
}

public func fix<T : Comparable>(x: T,betweenMin minValue: T, max maxValue: T) -> T {
    assert(minValue <= maxValue)
    return max(minValue, min(x, maxValue))
}

extension Array {
    public func validIndexFor(index: Index) -> Index? {
        guard count > 0 else { return nil }
        return fix(index, betweenMin: startIndex, max: count - 1)
    }
}

extension Array where Element: UIView {
    func removeFromSuperview() {
        forEach { $0.removeFromSuperview() }
    }
    
}




