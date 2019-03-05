//
//  GameViewController.swift
//  SpriteKitTexture_Mac
//
//  Created by Toshihiro Goto on 2019/03/05.
//  Copyright © 2019 Toshihiro Goto. All rights reserved.
//

import SceneKit
import SpriteKit

class GameViewController: NSViewController {
    
    private var skScene: SKScene!
    private var skParticle:SKEmitterNode!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // create a new scene
        let scene = SCNScene(named: "art.scnassets/ship.scn")!
        
        // create and add a light to the scene
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light!.type = .omni
        lightNode.position = SCNVector3(x: 0, y: 10, z: 10)
        scene.rootNode.addChildNode(lightNode)
        
        // create and add an ambient light to the scene
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = .ambient
        ambientLightNode.light!.color = NSColor.darkGray
        scene.rootNode.addChildNode(ambientLightNode)
        

        // retrieve the ship node
        let ship = scene.rootNode.childNode(withName: "box", recursively: true)!
        
        // animate the 3d object
        ship.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: 2, z: 0, duration: 4)))
        
        
        skScene = SKScene(size: CGSize.init(width: 1024, height: 1024))
        skScene.anchorPoint = CGPoint(x:0.5, y: 0.5)
        skScene.backgroundColor = NSColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1.0)
        
        skScene.isPaused = false
        
        skParticle = SKEmitterNode(fileNamed: "particle.sks")!
        skParticle.particleBirthRate = 0
        skScene.addChild(skParticle)
        
        ship.geometry?.firstMaterial?.multiply.contents = skScene
        
        
        // retrieve the SCNView
        let scnView = self.view as! SCNView
        
        // set the scene to the view
        scnView.scene = scene
        
        // allows the user to manipulate the camera
        scnView.allowsCameraControl = true
        
        // show statistics such as fps and timing information
        scnView.showsStatistics = true
        
        // configure the view
        scnView.backgroundColor = NSColor.black
        
        // Add a click gesture recognizer
        let clickGesture = NSClickGestureRecognizer(target: self, action: #selector(handleClick(_:)))
        var gestureRecognizers = scnView.gestureRecognizers
        gestureRecognizers.insert(clickGesture, at: 0)
        scnView.gestureRecognizers = gestureRecognizers
    }
    
    @objc
    func handleClick(_ gestureRecognizer: NSGestureRecognizer) {
        // retrieve the SCNView
        let scnView = self.view as! SCNView
        
        // check what nodes are clicked
        let p = gestureRecognizer.location(in: scnView)
        let hitResults = scnView.hitTest(p, options: [:])
        // check that we clicked on at least one object
        if hitResults.count > 0 {
            
            if skParticle.particleBirthRate == 0 {
               skParticle.particleBirthRate = 2000
            }else{
               skParticle.particleBirthRate = 0
            }
            
            // retrieved the first clicked object
            let result = hitResults[0]
            
            // get its material
            let material = result.node.geometry!.firstMaterial!
            
            // highlight it
            SCNTransaction.begin()
            SCNTransaction.animationDuration = 0.5
            
            // on completion - unhighlight
            SCNTransaction.completionBlock = {
                SCNTransaction.begin()
                SCNTransaction.animationDuration = 0.5
                
                material.emission.contents = NSColor.black
                
                SCNTransaction.commit()
            }
            
            material.emission.contents = NSColor.red
            
            SCNTransaction.commit()
        }
    }
}
