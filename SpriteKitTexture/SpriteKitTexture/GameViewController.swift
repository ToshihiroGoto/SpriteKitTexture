//
//  GameViewController.swift
//  SpriteKitTexture
//
//  Created by Toshihiro Goto on 2019/03/05.
//  Copyright © 2019 Toshihiro Goto. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit
import SpriteKit

class GameViewController: UIViewController {

    private var skScene: SKScene!
    private var skParticle: SKEmitterNode!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // create a new scene
        let scene = SCNScene(named: "main.scn")!
        
        
        // ----------------------------------
        // SceneKit Texture (SKScene)
        // ----------------------------------

        skScene = SKScene(fileNamed: "texture.sks")
        skScene.isPaused = false
        
        skParticle = skScene.childNode(withName: "particle")! as? SKEmitterNode
        
        // ----------------------------------
        // Geometry
        // ----------------------------------
        
        // retrieve the ship node
        let ballNode = scene.rootNode.childNode(withName: "box", recursively: true)!
        
        // animate the 3d object
        ballNode.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: 2, z: 0, duration: 4)))
        
        // Set SKScene
        ballNode.geometry?.firstMaterial?.diffuse.contents = skScene
        
        
        // ----------------------------------
        
        
        // retrieve the SCNView
        let scnView = self.view as! SCNView
        
        // set the scene to the view
        scnView.scene = scene
        
        // allows the user to manipulate the camera
        scnView.allowsCameraControl = true
        
        // show statistics such as fps and timing information
        scnView.showsStatistics = true
        
        // configure the view
        scnView.backgroundColor = UIColor.black
        
        // add a tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        scnView.addGestureRecognizer(tapGesture)
    }
    
    @objc
    func handleTap(_ gestureRecognize: UIGestureRecognizer) {
        // retrieve the SCNView
        let scnView = self.view as! SCNView
        
        // check what nodes are tapped
        let p = gestureRecognize.location(in: scnView)
        let hitResults = scnView.hitTest(p, options: [:])
        // check that we clicked on at least one object
        if hitResults.count > 0 {
            // retrieved the first clicked object
            //let result = hitResults[0]
            
            
            // --------------------------------------
            // SpriteKit Texture - Animation ON/OFF
            // --------------------------------------
            if skParticle.particleBirthRate == 0 {
                skParticle.particleBirthRate = 2000
            }else{
                skParticle.particleBirthRate = 0
            }
            // --------------------------------------
            
            
//            // get its material
//            let material = result.node.geometry!.firstMaterial!
//
//            // highlight it
//            SCNTransaction.begin()
//            SCNTransaction.animationDuration = 0.5
//
//            // on completion - unhighlight
//            SCNTransaction.completionBlock = {
//                SCNTransaction.begin()
//                SCNTransaction.animationDuration = 0.5
//
//                material.emission.contents = UIColor.black
//
//                SCNTransaction.commit()
//            }
//
//            material.emission.contents = UIColor.red
//
//            SCNTransaction.commit()
        }
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

}
