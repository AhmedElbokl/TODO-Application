//
//  ToDosVC.swift
//  TODO Application
//
//  Created by ReMoSTos on 09/08/2023.
//

import UIKit
import CoreData

class ToDosVC: UIViewController {
    
    var todoArray: [Todo] = []
    
    @IBOutlet weak var todosTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.todoArray = CoreDataManager.manage.retriveTodo()
        // new todo notification
        NotificationCenter.default.addObserver(self, selector: #selector(newTodoAdded), name: NSNotification.Name("newTodoAdded"), object: nil)
        
        // update todo notification
        NotificationCenter.default.addObserver(self, selector: #selector(currentTodoUpdated), name: NSNotification.Name("currentTodoUpdated"), object: nil)
        
        // delete todo notification
        NotificationCenter.default.addObserver(self, selector: #selector(currentTodoDeleted), name: NSNotification.Name("currentTodoDeleted"), object: nil)
        
        navigationItem.title = "TODOS"
        todosTableView.dataSource = self
        todosTableView.delegate = self
        
    }
    // related add notfication
    @objc func newTodoAdded(notification: Notification){
        let todo = notification.userInfo?["newTodo"] as? Todo
        if let myTodo = todo {
            todoArray.append(myTodo)
            CoreDataManager.manage.createTodo(todo: myTodo)
        }
        todosTableView.reloadData()
    }
    
    // related update notfication
    @objc func currentTodoUpdated(notification: Notification){
        if let updatedTodo = notification.userInfo?["updatedTodo"] as? Todo {
            if let updatedTodoIndex = notification.userInfo?["updatedTodoIndex"] as? Int {
                todoArray[updatedTodoIndex] = updatedTodo
                CoreDataManager.manage.updateTodo(todo: updatedTodo, index: updatedTodoIndex)
            }
        }
        todosTableView.reloadData()
    }
    
    // related delete notfication
    @objc func currentTodoDeleted(notification: Notification){
        if let index = notification.userInfo?["deletedTodoIndex"] as? Int {
            todoArray.remove(at: index)
            CoreDataManager.manage.deleteTodo(index: index)
        }
        todosTableView.reloadData()
    }
}



extension ToDosVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        todoArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCell") as! ToDoCell
        let todo = todoArray[indexPath.row]
        cell.todoTitleLabel.text = todo.title
        
        //cell.todoImageView.image = /*todo.image*/ UIImage(named: "p1")
        if let image = todo.image {
            cell.todoImageView.image = image
        } else {
            cell.todoImageView.image = UIImage(named: "p4")
        }
        
        cell.todoImageView.layer.cornerRadius = 35
        //(cell.todoImageView.frame.width + cell.todoImageView.frame.height) / 4
        return cell
    }
}

extension ToDosVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let todoDetailsVC = mainStoryboard.instantiateViewController(withIdentifier: "ToDoDetailsVC") as! ToDoDetailsVC
        todoDetailsVC.todo = todoArray[indexPath.row]
        todoDetailsVC.index = indexPath.row
        navigationController?.pushViewController(todoDetailsVC, animated: true)
    }
}
