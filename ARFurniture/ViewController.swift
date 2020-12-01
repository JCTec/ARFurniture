//
//  ViewController.swift
//  ARFurniture
//
//  Created by Juan Carlos on 23/11/20.
//

import UIKit
import ARKit
import RealityKit

class ViewController: UIViewController {
    
    @IBOutlet weak var arView: ARView!
    var scene: Couch.Scene!
    
    var didSetUp: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addCoaching()
    }
    
    private func setupArView() {
        guard let couchScene: Couch.Scene = try? Couch.loadScene() else { return }
        scene = couchScene
        scene.generateCollisionShapes(recursive: true)
        arView.scene.anchors.append(scene)
        // arView.debugOptions = [.showPhysics]
        didSetUp = true

        guard let couch = scene.couch as? Entity & HasCollision else { return }
        arView.installGestures(.all, for: couch)
        
        guard let chair = scene.chair as? Entity & HasCollision else { return }
        arView.installGestures(.all, for: chair)
    }
}

extension ViewController: ARCoachingOverlayViewDelegate {
    func addCoaching() {
        // Create a ARCoachingOverlayView object
        let coachingOverlay = ARCoachingOverlayView()
        // Make sure it rescales if the device orientation changes
        coachingOverlay.translatesAutoresizingMaskIntoConstraints = false
        
        self.arView.addSubview(coachingOverlay)
        // Set the Augmented Reality goal
        coachingOverlay.goal = .horizontalPlane
        // Set the ARSession
        coachingOverlay.session = self.arView.session
        // Set the delegate for any callbacks
        coachingOverlay.delegate = self
        
        NSLayoutConstraint.activate([
            coachingOverlay.topAnchor.constraint(equalTo: view.topAnchor, constant: 0.0),
            coachingOverlay.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0.0),
            coachingOverlay.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0.0),
            coachingOverlay.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0.0)
        ])
    }
    // Example callback for the delegate object
    
    public func coachingOverlayViewDidDeactivate(_ coachingOverlayView: ARCoachingOverlayView) {
        if !didSetUp {
            setupArView()
        }
    }
}
