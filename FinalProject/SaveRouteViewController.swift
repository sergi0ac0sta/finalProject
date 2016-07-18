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
    private let picker = UIImagePickerController()
    
    var capturedPoints: [CLLocation] = [CLLocation]()
    var capturedImage: UIImage? = nil
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var imageSelector: UISegmentedControl!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBAction func backgroundTap(sender: UIControl) {
        nameTextField.resignFirstResponder()
        descriptionTextView.resignFirstResponder()
    }
    
    @IBAction func textFieldDidEndEditing(textField: UITextField) {
        textField.resignFirstResponder()
    }
    
    @IBAction func selectImageAction(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
            case 1:
                picker.sourceType = UIImagePickerControllerSourceType.Camera
                presentViewController(picker, animated: true, completion: nil)
            case 2:
                picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
                presentViewController(picker, animated: true, completion: nil)
            default:
                capturedImage = nil
                imageView.image = nil
        }
    }
    
    @IBAction func saveButtonAction(sender: UIBarButtonItem) {
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
    }
    
    override func viewDidDisappear(animated: Bool) {
        nameTextField.text = "";
        descriptionTextView.text = "";
    }
    
    override func viewWillAppear(animated: Bool) {
        if imageView.image == nil {
            imageSelector.selectedSegmentIndex = 0
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        capturedImage = image
        imageView.image = image
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func sendAlert(title: String, message: String) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: UIAlertControllerStyle.Alert)
        let action = UIAlertAction(title: "OK",
                                   style: UIAlertActionStyle.Cancel) { _ in
        }
        alert.addAction(action)
        self.presentViewController(alert, animated: true, completion: nil)
    }
}
