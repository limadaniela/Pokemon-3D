//
//  ViewController.swift
//  Pokemon3D
//
//  Created by D L on 2023-01-15.
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
        
        //to add light to a 3D scene
        sceneView.autoenablesDefaultLighting = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //ARImageTrackingConfiguration as we're looking for a specific image provided
        let configuration = ARImageTrackingConfiguration()
        
        //to tell app about the images it should track
        if let imageToTrack = ARReferenceImage.referenceImages(inGroupNamed: "Pokemon Cards", bundle: Bundle.main) {
            configuration.trackingImages = imageToTrack
            
            //to tell configuration number of images to track
            configuration.maximumNumberOfTrackedImages = 1
            
            print("Images Successfully Added")
        }
        

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    
    //when image gets detected, this method will get called
    //in response node will provide a 3D object to be rendered into the screen
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        //new node object
        let node = SCNNode()
        
        //to check if detected item is an ARImageAnchor
        if let imageAnchor = anchor as? ARImageAnchor {
            //if ARImageAnchor detected
            let plane = SCNPlane(
                width: imageAnchor.referenceImage.physicalSize.width,
                height: imageAnchor.referenceImage.physicalSize.height
            )
            
            //to make our plane transparent
            plane.firstMaterial?.diffuse.contents = UIColor(white: 1.0, alpha: 0.5)
            
            //use plane dimensions to create a planeNode
            //this is going to be the 3D object that we're going to render just on top of card
            let planeNode = SCNNode(geometry: plane)
            
            //to rotate plane from vertical to horizontal position
            planeNode.eulerAngles.x = -.pi / 2
            
            node.addChildNode(planeNode)
            
            //to place Eevee 3D model on top of planeNode
            if let pokeScene = SCNScene(named: "art.scnassets/eevee.scn") {
                if let pokeNode = pokeScene.rootNode.childNodes.first {
                    //to rotate image to be placed on the top of the card
                    pokeNode.eulerAngles.x = .pi / 2
                    
                    //to add pokeNode to planeNode
                    planeNode.addChildNode(pokeNode)
                }
            }
        }
        
        return node
    }

}


