//
//  StyleKit.swift
//  ProjectName
//
//  Created by AuthorName on 15/12/15.
//  Copyright (c) 2015 CompanyName. All rights reserved.
//
//  Generated by PaintCode (www.paintcodeapp.com)
//



import UIKit

public class StyleKit : NSObject {

    //// Drawing Methods

    public class func drawSegmentedSelectedImage(frame frame: CGRect = CGRectMake(0, 0, 66, 28)) {

        //// Rectangle Drawing
        let rectanglePath = UIBezierPath(rect: CGRectMake(frame.minX + 6, frame.minY + frame.height - 6, frame.width - 11, 6))
        UIColor.greenColor().setFill()
        rectanglePath.fill()
    }

    public class func drawSegmentedImage(frame frame: CGRect = CGRectMake(0, 0, 66, 28)) {

        //// Rectangle Drawing
        let rectanglePath = UIBezierPath(rect: CGRectMake(frame.minX + 6, frame.minY + frame.height - 6, frame.width - 11, 6))
        UIColor.lightGrayColor().setFill()
        rectanglePath.fill()
    }

    //// Generated Images

    public class func imageOfSegmentedSelectedImage(frame frame: CGRect = CGRectMake(0, 0, 66, 28)) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(frame.size, false, 0)
            StyleKit.drawSegmentedSelectedImage(frame: CGRectMake(0, 0, frame.size.width, frame.size.height))

        let imageOfSegmentedSelectedImage = UIGraphicsGetImageFromCurrentImageContext().imageWithRenderingMode(.AlwaysOriginal)
        UIGraphicsEndImageContext()

        return imageOfSegmentedSelectedImage
    }

    public class func imageOfSegmentedImage(frame frame: CGRect = CGRectMake(0, 0, 66, 28)) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(frame.size, false, 0)
            StyleKit.drawSegmentedImage(frame: CGRectMake(0, 0, frame.size.width, frame.size.height))

        let imageOfSegmentedImage = UIGraphicsGetImageFromCurrentImageContext().imageWithRenderingMode(.AlwaysOriginal)
        UIGraphicsEndImageContext()

        return imageOfSegmentedImage
    }

}