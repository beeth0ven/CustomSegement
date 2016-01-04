//
//  SegmentedVCSubVC.swift
//  CustomSegement
//
//  Created by luojie on 15/12/24.
//  Copyright © 2015年 LuoJie. All rights reserved.
//

import UIKit

class SegmentedVCSubVC: UIViewController {
    var viewController: UIViewController? {
        return parentViewController?.parentViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("\(title!) \(__FUNCTION__)")
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        print("\(title!) \(__FUNCTION__)")
    }
}