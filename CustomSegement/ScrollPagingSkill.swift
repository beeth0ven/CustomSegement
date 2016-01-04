//
//  ScrollPagingSkill.swift
//  CustomSegement
//
//  Created by luojie on 15/12/24.
//  Copyright © 2015年 LuoJie. All rights reserved.
//

import UIKit

protocol ScrollPagingSkill {
    var pagable: Pagable! { get }
    var scrollView: UIScrollView! { get set }
}

extension ScrollPagingSkill {
    func pageDidChange() {
        updateScrollViewContentOffset(animated: true)
    }
    
    func scrollViewContentOffsetDidChange() {
        let index = Int(scrollView.contentOffset.x / scrollView.bounds.width)
        pagable.selectedIndex = index
    }
    
    func updateScrollViewContentOffset(animated animated: Bool) {
        let offsetX = CGFloat(pagable.selectedIndex) * scrollView.bounds.width
        scrollView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: animated)
    }
}

protocol Pagable: class {
    var selectedIndex: Int { get set }
}

extension SegmentedControl: Pagable { }

extension UIPageControl: Pagable{
    var selectedIndex: Int {
        get { return currentPage }
        set { currentPage = newValue }
    }
}