//
//  ViewController.swift
//  ARDice
//
//  Created by AKIL KUMAR THOTA on 1/2/18.
//  Copyright © 2018 AKIL KUMAR THOTA. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        
//        let cube = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0.01)
//        let sphere = SCNSphere(radius: 0.2)
//        let material = SCNMaterial()
//        material.diffuse.contents = UIImage(named: "art.scnassets/moon.jpg")
//
//        sphere.materials = [material]
//
//        let node = SCNNode()
//        node.position = SCNVector3(0, 0.1, -0.5)
//        node.geometry = sphere
//
//        sceneView.scene.rootNode.addChildNode(node)
//        sceneView.automaticallyUpdatesLighting = true
//        sceneView.autoenablesDefaultLighting = true
        
        


        // Set the scene to the view
        sceneView.automaticallyUpdatesLighting = true
        sceneView.autoenablesDefaultLighting = true
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let firstTouch = touches.first {
            let touchLocation = firstTouch.location(in: sceneView)
            let result = sceneView.hitTest(touchLocation, types: .existingPlaneUsingExtent)
            if !result.isEmpty {
                let hitResult = result.first!
                // Create a new scene
                let diceScene = SCNScene(named: "art.scnassets/diceCollada.scn")!
                if let diceNode = diceScene.rootNode.childNode(withName: "Dice", recursively: true) {
                diceNode.position = SCNVector3(hitResult.worldTransform.columns.3.x, hitResult.worldTransform.columns.3.y + diceNode.boundingSphere.radius, hitResult.worldTransform.columns.3.z)
                sceneView.scene.rootNode.addChildNode(diceNode)
                    
                    let randomx = Float(arc4random_uniform(4) + 1) * (Float.pi / 2)
                    let randomz = Float(arc4random_uniform(4) + 1) * (Float.pi / 2)
                    diceNode.runAction(SCNAction.rotateBy(x: CGFloat(randomx * 5), y: 0, z: CGFloat(randomz * 5), duration: 0.5))
        
                }
                
            }else{
                return
            }
        }
    }
    
    

    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if anchor is ARPlaneAnchor {
            let planeAnchor = anchor as! ARPlaneAnchor
            let plane = SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z))
            
            let planeNode = SCNNode(geometry: plane)
            planeNode.position = SCNVector3(planeAnchor.center.x, 0, planeAnchor.center.z)
            planeNode.transform = SCNMatrix4MakeRotation(-Float.pi / 2, 1, 0, 0)
            
            let gridMaterial = SCNMaterial()
            gridMaterial.diffuse.contents = UIImage(named: "art.scnassets/grid.png")
            plane.materials = [gridMaterial]
            
            node.addChildNode(planeNode)
        }else{
            return
        }
    }

    
    
}
