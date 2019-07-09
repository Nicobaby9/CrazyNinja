//
//  GameScene.swift
//  CrazyNinja
//
//  Created by sarkom-1 on 14/06/19.
//  Copyright © 2019 Aerials. All rights reserved.
//

import SpriteKit
import GameplayKit


enum GamePhase {
    case Ready
    case InPlay
    case GameOver
}

class GameScene: SKScene {
    
    var promptLabel = SKLabelNode()
    var scoreLabel = SKLabelNode()
    var bestLabel = SKLabelNode()
    
    var gamePhase = GamePhase.Ready
    var score = 0
    var best = 0
    var misses = 0
    var missesMax = 3
    
    var fruitThrowTimer = Timer()
    var xMarks = XMarks()
    var explodeOverlay = SKShapeNode()
    
    override func didMove(to view: SKView) {
        physicsWorld.gravity = CGVector(dx: 0, dy: -2)
        
        scoreLabel = childNode(withName: "score_label") as! SKLabelNode
        scoreLabel.text = "\(score)"
        bestLabel = childNode(withName: "best_label") as! SKLabelNode
        bestLabel.text = "Best: \(best)"
        promptLabel = childNode(withName: "prompt_label") as! SKLabelNode
        
        xMarks = XMarks(num: missesMax)
        xMarks.position = CGPoint(x: size.width-60, y: size.height-60)
        addChild(xMarks)
        
        
        explodeOverlay = SKShapeNode(rect: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        explodeOverlay.fillColor = .white
        addChild(explodeOverlay)
        explodeOverlay.alpha = 0
        
        //Load Best Score Data
        if UserDefaults.standard.object(forKey: "best") != nil {
            best = UserDefaults.standard.object(forKey: "best") as! Int
        }
        
    
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if gamePhase == .Ready {
            gamePhase = .InPlay
            startGame()
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            let location = t.location(in: self)
            let previous = t.previousLocation(in: self)
            
            
            for node in nodes(at: location) {
                if node.name == "fruit" {
                    score += 1
                    scoreLabel.text = "\(score)"
                    node.removeFromParent()
                    particleEffect(position: node.position)
                }
                
                if node.name == "bomb" {
                    score -= 5
                    scoreLabel.text = "\(score)"
                    bombExplode()
                    node.removeFromParent()
                    particleEffect(position: node.position)
                }
                
                if node.name == "dead" {
                    scoreLabel.text = "\(score)"
                    bombExplode()
                    gameOver()
                    node.removeFromParent()
                    particleEffect(position: node.position)
                }
                
                if score < 0 {
                    gameOver()
                    particleEffect(position: node.position)
                }
            }
            
            let line = TrailLine(pos: location, lastpos: previous, width: 8, color: .red)
            addChild(line)
        }
    }
    
    override func didSimulatePhysics() {
        
        for fruit in children {
            missesMax = 5
            if fruit.position.y < -100 {
                fruit.removeFromParent()
                if fruit.name == "fruit" {
                    
                    missFruits()
//                if misses == missesMax{
//
//                    gameOver()
//                    bombExplode()
//                }
                }
                print(misses)
            }
        }
        
        
        
    }
    
    func startGame() {
        score = 0
        
        scoreLabel.text = "\(score)"
        
        bestLabel.text = "\(best)"
        
        promptLabel.isHidden = true
        
        misses = 0
        
        xMarks.reset()
        
        fruitThrowTimer = Timer.scheduledTimer(withTimeInterval: 1.2, repeats: true, block: {_ in self.createFruits()})
    }
    
    func createFruits() {
//        print("test fruits")
        
            let numberOfFruits = Int(arc4random_uniform(UInt32(4)))
        
            for _ in 0..<numberOfFruits{
            
            let fruit = Fruits()
            fruit.position.x = randomCGFloat(0, size.width)
            fruit.position.y = -100
            addChild(fruit)
            
            if fruit.position.x < size.width/2 {
                fruit.physicsBody?.velocity.dx = randomCGFloat(0, 200)
            }
            
            if fruit.position.x > size.width/2 {
                fruit.physicsBody?.velocity.dx = randomCGFloat(0, -200)
            }
            fruit.physicsBody?.velocity.dy = randomCGFloat(500, 800)
            fruit.physicsBody?.angularVelocity = randomCGFloat(-5, 5)
        }
    }
    
    func missFruits() {
        misses += 1
        
        xMarks.update(num: misses)
        
        if misses == missesMax{
            bombExplode()
            gameOver()
        }
        
    }
    
    func bombExplode() {
        
        for case let fruit as Fruits in children {
            fruit.removeFromParent()
            //explode
            
            particleEffect(position: fruit.position)
        }
        
        explodeOverlay.run(SKAction.sequence([
            SKAction.fadeAlpha(to: 1, duration: 0),
            SKAction.wait(forDuration: 0.2),
            SKAction.fadeAlpha(to: 0, duration: 0),
            SKAction.wait(forDuration: 0.2),
            SKAction.fadeAlpha(to: 1, duration: 0),
            SKAction.wait(forDuration: 0.2),
            SKAction.fadeAlpha(to: 0, duration: 0)
            
            ]))
        
        //sound
    }
    
    func gameOver() {
        if score > best {
            best = score
            
            //Save Best Score Data
            UserDefaults.standard.set(best, forKey: "my save data")
            UserDefaults.standard.synchronize()
        }
        
        
        promptLabel.isHidden = false
        promptLabel.text = "Game Over!"
        promptLabel.setScale(0)
        promptLabel.run(SKAction.scale(to: 1, duration: 0.3))
        
        gamePhase = .GameOver
        
        fruitThrowTimer.invalidate()
        
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false, block: {_ in self.gamePhase = .Ready})
        
    }
    
    func particleEffect(position: CGPoint) {
        
        let emitter = SKEmitterNode(fileNamed: "Explode.sks")
        emitter?.position = position
        addChild(emitter!)
    }
}
