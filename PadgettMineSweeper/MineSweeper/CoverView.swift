//
//  CoverView.swift
//  MineSweeper
//
//  Created by Michelle Padgett on 2/20/17.
//  Copyright © 2017 SSU. All rights reserved.
//


import UIKit

class CoverView: UIView {
    
    private struct Offsets {
        static let radiusFactor = 0.25
        static let lineGapFactor = 0.10
        static let diagonalTopLeftBottomRightGapFactor = 0.2
        static let diagonalBottomLeftTopRightGapFactor = diagonalTopLeftBottomRightGapFactor
        static let heightFactor = 0.10
        static let diagonalLineWidth = 0.10
    }
    
    override func draw(_ rect: CGRect) {
        let width = Double(bounds.size.width)
        let height = Double(bounds.size.height)
        
  //      let centerPoint = CGPoint(x: bounds.midX, y: bounds.midY)
        
        let radius = Offsets.radiusFactor * Double(width)
        print(width, radius)
        //let centerCircle = UIBezierPath(arcCenter: centerPoint, radius: CGFloat(radius), startAngle: 0.0, endAngle: CGFloat(2 * M_PI), clockwise: false)
        
   //     let horizontalRect = CGRect(origin: Double(bounds.size.width), size: Double(bounds.size.height) )
       let vertialRec = CGRect(x: width,
                                y: height,
                                width: width ,
                                height: height)
        
        //let horizontalLine = UIBezierPath(rect: horizontalRect)
      let verticalLine = UIBezierPath(rect: vertialRec)
     
        
        UIColor.purple.setFill()
        verticalLine.fill()
        
    }
    
}

