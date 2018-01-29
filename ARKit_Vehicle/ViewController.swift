//
//  ViewController.swift
//  ARKit_Vehicle
//
//  Created by IJke Botman on 29/01/2018.
//  Copyright © 2018 IJke Botman. All rights reserved.
//

import UIKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet weak var sceneView: ARSCNView!
    let configuration = ARWorldTrackingConfiguration()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sceneView.delegate = self
        self.configuration.planeDetection = .horizontal
        self.sceneView.session.run(configuration)
        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        let lavaNode = createLava(planeAnchor: planeAnchor)
        node.addChildNode(lavaNode)
        print("New flat surface detected, new ARPlaneAnchor added")
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        node.enumerateChildNodes { (childNode, _) in
            childNode.removeFromParentNode()
        }
        let lavaNode = createLava(planeAnchor: planeAnchor)
        node.addChildNode(lavaNode)
        print("Updating plane anchor")
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
        guard let _ = anchor as? ARPlaneAnchor else { return }
        node.enumerateChildNodes { (childNode, _) in
            childNode.removeFromParentNode()
        }
    }
    
    func createLava(planeAnchor: ARPlaneAnchor) -> SCNNode {
        let lavaNode = SCNNode(geometry: SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z)))
        lavaNode.geometry?.firstMaterial?.diffuse.contents = #imageLiteral(resourceName: "lava")
        lavaNode.position = SCNVector3(planeAnchor.center.x, planeAnchor.center.y, planeAnchor.center.z)
        lavaNode.geometry?.firstMaterial?.isDoubleSided = true
        lavaNode.eulerAngles = SCNVector3(90.degreesToRadians, 0, 0)
        return lavaNode
    }
    
    
}

extension Int {
    var degreesToRadians: Double { return Double(self) * .pi / 180 }
}



