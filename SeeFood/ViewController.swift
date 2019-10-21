//
//  ViewController.swift
//  SeeFood
//
//  Created by Emily Cheroske on 10/13/19.
//  Copyright © 2019 Emily Cheroske. All rights reserved.
//

import UIKit
import CoreML
import Vision
import ChameleonFramework
import SwiftySound

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, ChangeImageDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var messageImage: UIImageView!
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(UIImagePickerController.isSourceTypeAvailable(.camera)) {
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = false
        } else {
            print("You can't use the camera on a simulator")
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let userPickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = userPickedImage
            imagePicker.dismiss(animated: true, completion: nil)
            
            guard let ciImage = CIImage(image: userPickedImage) else {
                fatalError("Could not convert to CIImage")
            }
            
            detect(image: ciImage)
            
        }
    }
    
    func detect(image: CIImage) {
        
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else {
            fatalError("Could not instantiate model")
        }
        
        let request = VNCoreMLRequest(model: model) { (request, error) in
            guard let results = request.results as? [VNClassificationObservation] else {
                fatalError("Model failed to process image")
            }
            
            if let firstResult = results.first {
                if(firstResult.identifier.contains("hotdog")) {
                    self.messageImage.image = UIImage(named: "goodhotdog")
                    Sound.play(file: "chime2.wav")
                } else {
                    self.messageImage.image = UIImage(named: "badhotdog")
                }
            }
            print(results)
        }
        
        let handler = VNImageRequestHandler(ciImage: image)
        
        do {
            try! handler.perform([request])
        } catch {
            print("\(error)")
        }
        
    }
    
    func updateImage(image: UIImage) {
        print("Call from update image")
        
        imageView.image = image
        
        guard let ciImage = CIImage(image: image) else {
            fatalError("Could not convert to CIImage")
        }
        
        detect(image: ciImage)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showAR" {
            print("came back with images!")
            let destinationVC = segue.destination as! SceneKitViewController
            destinationVC.changeImageDelegate = self
        }
    }

    @IBAction func CameraTapped(_ sender: Any) {
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func PhotoLibraryPressed(_ sender: Any) {
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func ARButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "showAR", sender: self)
    }
}

