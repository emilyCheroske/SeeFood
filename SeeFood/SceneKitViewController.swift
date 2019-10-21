//
//  SceneKitViewController.swift
//  SeeFood
//
//  Created by Emily Cheroske on 10/20/19.
//  Copyright © 2019 Emily Cheroske. All rights reserved.
//

import UIKit
import ARKit

protocol ChangeImageDelegate {
    func updateImage(image : UIImage)
}

class SceneKitViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet weak var sceneView: ARSCNView!
    
    var changeImageDelegate : ChangeImageDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        
        // Set the view's delegate
        sceneView.delegate = self

        //sceneView.showsStatistics = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
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
        if let touch = touches.first {
            
            let touchLocation = touch.location(in: self.sceneView)
            
            let results = sceneView.hitTest(touchLocation, types: .existingPlaneUsingExtent)
            
            if let hitresult = results.first {
                let diceScene = SCNScene(named: "sceneKitAssets.scnassets/hotdog.scn")!
        
                if let bunNode = diceScene.rootNode.childNode(withName: "bun", recursively: true) {
        
                    bunNode.position = SCNVector3(
                        hitresult.worldTransform.columns.3.x,
                        hitresult.worldTransform.columns.3.y,
                        hitresult.worldTransform.columns.3.z)
                    
                    sceneView.scene.rootNode.addChildNode(bunNode)
                }
                
                if let ketchupNode = diceScene.rootNode.childNode(withName: "ketchup", recursively: true) {
                
                    ketchupNode.position = SCNVector3(
                        hitresult.worldTransform.columns.3.x,
                        hitresult.worldTransform.columns.3.y,
                        hitresult.worldTransform.columns.3.z)
                    
                    sceneView.scene.rootNode.addChildNode(ketchupNode)
                }
                
                if let mustardNode = diceScene.rootNode.childNode(withName: "mustard", recursively: true) {
                
                    mustardNode.position = SCNVector3(
                        hitresult.worldTransform.columns.3.x,
                        hitresult.worldTransform.columns.3.y,
                        hitresult.worldTransform.columns.3.z)
                    
                    sceneView.scene.rootNode.addChildNode(mustardNode)
                }
                
                if let hotdogNode = diceScene.rootNode.childNode(withName: "hotdog", recursively: true) {
                
                    hotdogNode.position = SCNVector3(
                        hitresult.worldTransform.columns.3.x,
                        hitresult.worldTransform.columns.3.y,
                        hitresult.worldTransform.columns.3.z)
                    
                    sceneView.scene.rootNode.addChildNode(hotdogNode)
                }
            }
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
        if anchor is ARPlaneAnchor {
            let planeAnchor = anchor as! ARPlaneAnchor
            
            let plane = SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z))
            
            let planeNode = SCNNode()
            
            planeNode.position = SCNVector3(planeAnchor.center.x, 0, planeAnchor.center.z)
            
            planeNode.transform = SCNMatrix4MakeRotation(-Float.pi/2, 1, 0, 0)
            
            let gridMaterial = SCNMaterial()
            gridMaterial.diffuse.contents = UIImage(named: "sceneKitAssets.scnassets/grid.png")

            plane.materials = [gridMaterial]
            planeNode.geometry = plane
            
            node.addChildNode(planeNode)
            
        } else {
            return
        }
    }
    
    @IBAction func CaptureHotDog(_ sender: Any) {
        print("You captured the hotdog!")
        
        let image = sceneView.snapshot()
        
        changeImageDelegate?.updateImage(image: image)
        
        self.navigationController?.popViewController(animated: true)
        
    }
}
