//
//  SegmentedViewController.swift
//  CustomSegement
//
//  Created by luojie on 15/12/24.
//  Copyright © 2015年 LuoJie. All rights reserved.
//

import UIKit

class SegmentedViewController: UIViewController, UIScrollViewDelegate, ScrollPagingSkill, Pagable {
    
    @IBOutlet weak var segmentedControl: SegmentedControl!
    @IBOutlet weak var scrollView: UIScrollView!
    var pagable: Pagable! { return segmentedControl }
    
    var selectedIndex: Int {
        get { return pagable.selectedIndex }
        set { pagable.selectedIndex = newValue }
    }
    
    var selectedViewController: UIViewController {
        return viewControllersBySegueIdentifier[selectedIndex.segueIdentifier]!
    }
    
    @IBInspectable
    var animationEnable: Bool = true
    
    private var shouldLayout = true
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if shouldLayout {
            updateScrollViewContentOffset(animated: false)
        } else {
            shouldLayout = true
        }
    }
    
    @IBAction func changeViewController(sender: SegmentedControl) {
        shouldLayout = false
        performSafeSegueWithIdentifier(sender.selectedIndex.segueIdentifier, sender: sender)
        updateScrollViewContentOffset(animated: animationEnable)
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        scrollViewContentOffsetDidChange()
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        guard viewControllersBySegueIdentifier[identifier] == nil else { return false }
        return identifier == selectedIndex.segueIdentifier
    }
    
    private var viewControllersBySegueIdentifier: [String: UIViewController] = [:]
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        viewControllersBySegueIdentifier[segue.identifier!] = segue.destinationViewController
    }
}

extension UIViewController {
    func performSafeSegueWithIdentifier(identifier: String, sender: AnyObject?) {
        guard shouldPerformSegueWithIdentifier(identifier, sender: sender) else { return }
        performSegueWithIdentifier(identifier, sender: sender)
    }
}

private extension Int {
    var segueIdentifier: String {
        return "EmbedVC\(self)"
    }
}
