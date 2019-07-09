//
//  Fruits.swift
//  CrazyNinja
//
//  Created by sarkom-1 on 14/06/19.
//  Copyright © 2019 Aerials. All rights reserved.
//

import SpriteKit

class Fruits: SKNode {
    
    let fruitEmojis = ["🍎","🍊","🥝","🍐","🍒","🍓"]
    
    let bombEmoji = "💣"
    
    let deadEmoji = "☠️"
    
    override init() {
        super.init()
        
        var emoji = ""
        
        if randomCGFloat(0, 1) < 0.9 {
            name = "fruit"
            let n = Int(arc4random_uniform(UInt32(fruitEmojis.count)))
            emoji = fruitEmojis[n]
            
        } else if randomCGFloat(0, 1) < 0.7{
            name = "bomb"
            emoji = bombEmoji
            
        } else if randomCGFloat(0,1) < 0.6 {
            name = "dead"
            emoji = deadEmoji
        }
        
        
        let label = SKLabelNode(text: emoji)
        label.fontSize = 120
        label.verticalAlignmentMode = .center
        addChild(label)
        
        physicsBody = SKPhysicsBody()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
