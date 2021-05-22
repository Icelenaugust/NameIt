//
//  ViewController.swift
//  NameIt
//
//  Created by Youjia Ding on 19/5/21.
//

import CoreML
import UIKit

class ViewController: UIViewController,
                      UIImagePickerControllerDelegate,
                      UINavigationControllerDelegate {

    
    @IBOutlet weak var frontImage: UIImageView!
    
    @IBOutlet weak var objectName: UILabel!
    
    @IBOutlet weak var selectImage: UIButton!
    
    @IBOutlet weak var takePhotoButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func takePhoto(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
    
    
    
    
    @IBAction func chooseImage(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        present(picker, animated: true, completion: nil)
        print("Select image button pressed")
        
    }
    
    private func analyzeImage(image: UIImage?) {
        guard let buffer = image?.resize(size: CGSize(width: 224, height: 224))?.getCVPixelBuffer() else {
            return
        }
        
        do {
            let config = MLModelConfiguration()
            let model = try GoogLeNetPlaces(configuration: config)
            let input = GoogLeNetPlacesInput(sceneImage: buffer)
            
            let output = try model.prediction(input: input)
            let nameString = output.sceneLabel
            objectName.text = nameString
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info:[UIImagePickerController.InfoKey : Any]) {
        
        guard let frontPicture = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
        }
        
        frontImage.image = frontPicture
        analyzeImage(image: frontPicture)
        picker.dismiss(animated: true, completion: nil)
        
    }
    
}

