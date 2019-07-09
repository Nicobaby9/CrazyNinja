//
//  XMarks.swift
//  CrazyNinja
//
//  Created by sarkom-1 on 15/06/19.
//  Copyright © 2019 Aerials. All rights reserved.
//

import SpriteKit

class XMarks: SKNode {
    
    var xArray = [SKSpriteNode]()
    var numXs = Int()
    
    let blackxPic = SKTexture(imageNamed: "xblack")
    let redXPic = SKTexture(imageNamed: "xred")
    
    init(num: Int = 0) {
        super.init()
        numXs = num
        
        for i in 0..<num{
            let xMark = SKSpriteNode(imageNamed: "xblack")
            xMark.size = CGSize(width: 60, height: 60)
            xMark.position.x = -CGFloat(i)*70
            addChild(xMark)
            xArray.append(xMark)
        }
    }
    
    func update(num: Int) {
        if num <= numXs {
            
            xArray[xArray.count-num].texture = redXPic
        }
    }
    
    func reset(){
        for xMark in xArray {
            xMark.texture = blackxPic
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
