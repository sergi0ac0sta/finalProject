//
//  SaveRouteViewController.swift
//  FinalProject
//
//  Created by Sergio Acosta on 17/07/16.
//  Copyright © 2016 Sergio Acosta. All rights reserved.
//

import UIKit
import CoreLocation

class SaveRouteViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    fileprivate let picker = UIImagePickerController()
    
    var location: CLLocation = CLLocation()
    var capturedImage: UIImage? = nil
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var imageSelector: UISegmentedControl!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBAction func backgroundTap(_ sender: UIControl) {
        nameTextField.resignFirstResponder()
        descriptionTextView.resignFirstResponder()
    }
    
    @IBAction func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
    }
    
    @IBAction func selectImageAction(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
            case 1:
                picker.sourceType = UIImagePickerControllerSourceType.camera
                present(picker, animated: true, completion: nil)
            case 2:
                picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
                present(picker, animated: true, completion: nil)
            default:
                capturedImage = nil
                imageView.image = nil
        }
    }
    
    @IBAction func saveButtonAction(_ sender: UIBarButtonItem) {
        if nameTextField.text == ""{
            sendAlert("Error", message: "Debes ingresar al menos nombre a la ruta.")
        } else {
            //Save
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTextField.delegate = self
        descriptionTextView.delegate = self
        picker.delegate = self
        print(location.coordinate.latitude)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        nameTextField.text = "";
        descriptionTextView.text = "";
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if imageView.image == nil {
            imageSelector.selectedSegmentIndex = 0
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        capturedImage = image
        imageView.image = image
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func sendAlert(_ title: String, message: String) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction(title: "OK",
                                   style: UIAlertActionStyle.cancel) { _ in
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
}
