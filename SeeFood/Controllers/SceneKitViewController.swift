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
        
        addLight()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.environmentTexturing = .automatic
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
                    
                    let bunMaterial = SCNMaterial()
                    bunMaterial.lightingModel = .physicallyBased
                    bunMaterial.diffuse.contents = UIImage(named: "sceneKitAssets.scnassets/hotdog_texture2.jpg")
                    bunMaterial.normal.contents = UIImage(named: "sceneKitAssets.scnassets/hotdog_texture2_NORM.jpg")
                    bunMaterial.normal.intensity = 0.5
                    bunMaterial.metalness.contents = 0.3
                    bunMaterial.roughness.contents = 0.7
                    bunNode.geometry?.firstMaterial = bunMaterial
                    
                    sceneView.scene.rootNode.addChildNode(bunNode)
                }
                
                if let ketchupNode = diceScene.rootNode.childNode(withName: "ketchup", recursively: true) {
                
                    ketchupNode.position = SCNVector3(
                        hitresult.worldTransform.columns.3.x,
                        hitresult.worldTransform.columns.3.y,
                        hitresult.worldTransform.columns.3.z)
                    
                    let ketchupMaterial = SCNMaterial()
                    ketchupMaterial.lightingModel = .physicallyBased
                    ketchupMaterial.diffuse.contents = UIImage(named: "sceneKitAssets.scnassets/hotdog_texture2.jpg")
                    ketchupMaterial.normal.contents = UIImage(named: "sceneKitAssets.scnassets/hotdog_texture2_NORM.jpg")
                    ketchupMaterial.normal.intensity = 0.5
                    ketchupMaterial.metalness.contents = 0.1
                    ketchupMaterial.roughness.contents = 0.3
                    ketchupNode.geometry?.firstMaterial = ketchupMaterial
                    
                    sceneView.scene.rootNode.addChildNode(ketchupNode)
                }
                
                if let mustardNode = diceScene.rootNode.childNode(withName: "mustard", recursively: true) {
                
                    mustardNode.position = SCNVector3(
                        hitresult.worldTransform.columns.3.x,
                        hitresult.worldTransform.columns.3.y,
                        hitresult.worldTransform.columns.3.z)
                    
                    let mustardMaterial = SCNMaterial()
                    mustardMaterial.lightingModel = .physicallyBased
                    mustardMaterial.diffuse.contents = UIImage(named: "sceneKitAssets.scnassets/hotdog_texture2.jpg")
                    mustardMaterial.normal.contents = UIImage(named: "sceneKitAssets.scnassets/hotdog_texture2_NORM.jpg")
                    mustardMaterial.normal.intensity = 0.5
                    mustardMaterial.metalness.contents = 0.1
                    mustardMaterial.roughness.contents = 0.3
                    mustardNode.geometry?.firstMaterial = mustardMaterial
                    
                    sceneView.scene.rootNode.addChildNode(mustardNode)
                }
                
                if let hotdogNode = diceScene.rootNode.childNode(withName: "hotdog", recursively: true) {
                
                    hotdogNode.position = SCNVector3(
                        hitresult.worldTransform.columns.3.x,
                        hitresult.worldTransform.columns.3.y,
                        hitresult.worldTransform.columns.3.z)
                    
                    let hotdogMaterial = SCNMaterial()
                    hotdogMaterial.lightingModel = .physicallyBased
                    hotdogMaterial.diffuse.contents = UIImage(named: "sceneKitAssets.scnassets/hotdog_texture2.jpg")
                    hotdogMaterial.normal.contents = UIImage(named: "sceneKitAssets.scnassets/hotdog_texture2_NORM.jpg")
                    hotdogMaterial.normal.intensity = 0.5
                    hotdogMaterial.metalness.contents = 0.6
                    hotdogMaterial.roughness.contents = 0.6
                    hotdogNode.geometry?.firstMaterial = hotdogMaterial
                    
                    sceneView.scene.rootNode.addChildNode(hotdogNode)
                }
            }
        }
    }
    
    func addLight() {
        let directionalLight = SCNLight()
        directionalLight.type = .directional
        directionalLight.intensity = 1
        directionalLight.castsShadow = true
        directionalLight.shadowMode = .forward
        directionalLight.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        directionalLight.shadowSampleCount = 10
        
        let directionalLightNode = SCNNode()
        directionalLightNode.light = directionalLight
        directionalLightNode.rotation = SCNVector4Make(1, 0, 0, -Float.pi / 3)
        
        sceneView.scene.rootNode.addChildNode(directionalLightNode)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
        if anchor is ARPlaneAnchor {
            let planeAnchor = anchor as! ARPlaneAnchor
            
            let plane = SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z))
            
            let planeNode = SCNNode()
            
            planeNode.position = SCNVector3(planeAnchor.center.x, 0, planeAnchor.center.z)
            
            planeNode.transform = SCNMatrix4MakeRotation(-Float.pi/2, 1, 0, 0)
            
//            let gridMaterial = SCNMaterial()
//            gridMaterial.diffuse.contents = UIImage(named: "sceneKitAssets.scnassets/grid.png")
//
//            plane.materials = [gridMaterial]
            planeNode.geometry = plane
            
            plane.firstMaterial?.colorBufferWriteMask = .init(rawValue: 0)
            
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
