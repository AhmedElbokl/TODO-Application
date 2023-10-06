//
//  ToDoDetailsVC.swift
//  TODO Application
//
//  Created by ReMoSTos on 10/08/2023.
//

import UIKit

class ToDoDetailsVC: UIViewController {
    var todo: Todo!
    var index: Int!
    
    @IBOutlet weak var todoTitle: UILabel!
    @IBOutlet weak var todoDescription: UILabel!
    @IBOutlet weak var todoImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(currentTodoEdited), name: NSNotification.Name("currentTodoUpdated"), object: nil)
        todoTitle.text = todo.title
        todoDescription.text = todo.description
        
        if let image = todo.image {
            todoImageView.image = image
        }else {
            todoImageView.image = UIImage(named: "p4")
        }
    }
    
    @objc func currentTodoEdited(notification: Notification){
        if let todo = notification.userInfo?["updatedTodo"] as? Todo {
            todoTitle.text = todo.title
            todoDescription.text = todo.description
            todoImageView.image = todo.image
        }
    }
    
    
    @IBAction func updateBtnClicked(_ sender: Any) {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newTodoVC = mainStoryboard.instantiateViewController(withIdentifier: "NewToDoVC") as! NewToDoVC
        newTodoVC.isCreationScreen = false
        newTodoVC.updatedTodo = todo
        newTodoVC.updatedTodoIndex = index
        navigationController?.pushViewController(newTodoVC, animated: true)
    }
    
    @IBAction func deleteBtnClicked(_ sender: Any) {
        let confirmAlert = UIAlertController(title: "Deletion Confirmation", message: "Do You Need To Delete This Todo", preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "Confirm", style: .destructive) { _ in
            NotificationCenter.default.post(name: NSNotification.Name("currentTodoDeleted"), object: nil, userInfo: ["deletedTodoIndex" : self.index])
            let alert = UIAlertController(title: "Delete Todo", message: "A Selected Todo Wil Be Deleted", preferredStyle: .alert)
            let doneAction = UIAlertAction(title: "Done", style: .default) { _ in
                self.navigationController?.popViewController(animated: true)
            }
            alert.addAction(doneAction)
            self.present(alert, animated: true)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        confirmAlert.addAction(confirmAction)
        confirmAlert.addAction(cancelAction)
        present(confirmAlert, animated: true)
    }
    
    
}
