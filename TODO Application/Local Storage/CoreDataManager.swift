//
//  CoreDataModel.swift
//  TODO Application
//
//  Created by ReMoSTos on 06/10/2023.
//

import Foundation
import UIKit
import CoreData

class CoreDataManager {
    static let manage = CoreDataManager()
    //MARK: - Core Data
    //Create todo in core data
    public func createTodo(todo: Todo){
        // catch appdelegate
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        // catch database
        let context = appDelegate.persistentContainer.viewContext
        // catch an entity
        guard let todoEntity = NSEntityDescription.entity(forEntityName: "Todo", in: context) else {return}
        // create an object of this entity
        let newTodo = NSManagedObject(entity: todoEntity, insertInto: context)
        // (add recordes (data))
        // convert image to data
        guard let image = todo.image else {return}
        let dataImage = image.jpegData(compressionQuality: 0.9)
        //let dataImage = image?.pngData()
        newTodo.setValue(todo.title, forKey: "title")
        newTodo.setValue(todo.description, forKey: "details")
        newTodo.setValue(dataImage, forKey: "image")
        // save to context
        do{
            try context.save()
        }catch{
            print("can't add todo")
        }
    }
    
    public func retriveTodo() -> [Todo]{
        var todos: [Todo] = []
        // catch appdelegate
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        // catch database
        let context = appDelegate.persistentContainer.viewContext
        // fetch request
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Todo")
        
        do{
            // get array of fetched todos
            let fetchedTodo = try context.fetch(fetchRequest) as! [NSManagedObject]
            for todo in fetchedTodo {
                // convert data to image
                guard let dataImage = todo.value(forKey: "image") as? Data else {return []}
                let image = UIImage(data: dataImage)
                let todo: Todo = Todo(title: todo.value(forKey: "title") as! String, image: image, description: todo.value(forKey: "details") as? String )
                todos.append(todo)
            }
        }catch{
            print("can't fetch todo")
        }
        return todos
    }
    
    public func updateTodo(todo: Todo, index: Int) {
        // catch appdelegate
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        // catch database
        let context = appDelegate.persistentContainer.viewContext
        // fetch request
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Todo")
        
        do{
            // get array of fetched todos
            let fetchedTodo = try context.fetch(fetchRequest) as! [NSManagedObject]
            // update with new data
            // convert image to data
            guard let image = todo.image else{return}
            let dataImage = image.jpegData(compressionQuality: 0.9)
            //let dataImage = image?.pngData()
            fetchedTodo[index].setValue(dataImage, forKey: "image")
            fetchedTodo[index].setValue(todo.title, forKey: "title")
            fetchedTodo[index].setValue(todo.description, forKey: "details")
            // save to context
            try context.save()
            
        }catch{
            print("can't update todo")
        }
    }
    
    public func deleteTodo(index: Int){
        // catch appdelegate
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        // catch database
        let context = appDelegate.persistentContainer.viewContext
        // fetch request
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Todo")
        
        do{
            // get array of fetched todos
            let fetchedTodo = try context.fetch(fetchRequest) as! [NSManagedObject]
            let todoToDelete = fetchedTodo[index]
            context.delete(todoToDelete)
            // save to context
            try context.save()
            
        }catch{
            print("can't delete todo")
        }
    }
    
}
