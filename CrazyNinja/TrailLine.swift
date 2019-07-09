//
//  TrailLine.swift
//  CrazyNinja
//
//  Created by sarkom-1 on 14/06/19.
//  Copyright © 2019 Aerials. All rights reserved.
//

import SpriteKit

class TrailLine: SKShapeNode {
    
    var shrinkTimer = Timer()
    
    init(pos: CGPoint, lastpos: CGPoint, width: CGFloat, color: UIColor) {
        super.init()
        
        
        let path = CGMutablePath()
        path.move(to: pos)
        path.addLine(to: lastpos)
        
        self.path = path
        strokeColor = color
        lineWidth = width
        
        shrinkTimer = Timer.scheduledTimer(withTimeInterval: 0.02, repeats: true, block: {_ in self.lineWidth -= 1
            
            if self.lineWidth == 0 {
                self.shrinkTimer.invalidate()
                self.removeFromParent()
            }
            
        })
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
