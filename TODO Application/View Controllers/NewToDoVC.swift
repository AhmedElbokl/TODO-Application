//
//  NewToDoVC.swift
//  TODO Application
//
//  Created by ReMoSTos on 10/08/2023.
//

import UIKit

class NewToDoVC: UIViewController {
    
    var isCreationScreen = true
    var updatedTodo: Todo?
    var updatedTodoIndex: Int?
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var detailsTextView: UITextView!
    @IBOutlet weak var mainButton: UIButton!
    @IBOutlet weak var todoImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after
        
        navigationItem.title = "New Task"
        if !isCreationScreen {
            navigationItem.title = "Update Task"
            mainButton.setTitle("Update", for: .normal)
        }
        
        if let todo = updatedTodo {
            titleTextField.text = todo.title
            detailsTextView.text = todo.description
            todoImageView.image = todo.image
        }
    }
    
    @IBAction func addBtnClicked(_ sender: Any) {
        if isCreationScreen{
            let todo = Todo(title: titleTextField.text!, image: todoImageView.image, description: detailsTextView.text!)
            NotificationCenter.default.post(name: NSNotification.Name("newTodoAdded"), object: nil, userInfo: ["newTodo": todo])
            
            // new Todo Added Alert
            let alert = UIAlertController(title: "Add Todo", message: "A Todo Has Olready Added", preferredStyle: .alert)
            let doneAction = UIAlertAction(title: "Done", style: .default) { _ in
                // Go To TabBarController With Index 0
                self.tabBarController?.selectedIndex = 0
                
                //Empty the textfield and textview and imageView
                self.titleTextField.text = ""
                self.todoImageView.image = nil
                self.detailsTextView.text = ""
                
                
            }
            
            alert.addAction(doneAction)
            present(alert, animated: true)
            
            
            
        } else{
            //Edit Current Task.........
            let updatedTodo: Todo = Todo(title: titleTextField.text!, image: todoImageView.image, description: detailsTextView.text)
            NotificationCenter.default.post(name: NSNotification.Name("currentTodoUpdated"), object: nil, userInfo: ["updatedTodo" : updatedTodo, "updatedTodoIndex": updatedTodoIndex])
            
            // Current Todo Updated Alert
            let alert = UIAlertController(title: "Update Todo", message: "A Current Todo Will Be Updated", preferredStyle: .alert)
            let doneAction = UIAlertAction(title: "Done", style: .default) { _ in
                self.navigationController?.popViewController(animated: true)
            }
            alert.addAction(doneAction)
            present(alert, animated: true)
        }
    }
    
    // Image Picker Approach
    @IBAction func updateImageBtnClicked(_ sender: Any) {
        if isCreationScreen {
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .photoLibrary
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.allowsEditing = true
            imagePicker.delegate = self
            present(imagePicker, animated: true)
        }else {
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .photoLibrary
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.allowsEditing = true
            imagePicker.delegate = self
            present(imagePicker, animated: true)
        }
    }
}

// extension image picker protocols
extension NewToDoVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        if let image = info[.originalImage] as? UIImage {
            todoImageView.image = image
        }
    }
}

