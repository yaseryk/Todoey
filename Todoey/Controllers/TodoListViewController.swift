//
//  ViewController.swift
//  Todoey
//
//  Created by Yaser on 19/04/2018.
//  Copyright © 2018 YaserYK. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext


    var itemsArray = [Item]()
    
    var selectedCategory : Category? {
        didSet{
            loadItems()

        }
    }
    
    //let userDefault = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
//        let newItem1 = Item()
//        newItem1.title = "1"
//        itemsArray.append(newItem1)
//
//        let newItem2 = Item()
//        newItem2.title = "2"
//        itemsArray.append(newItem2)
//
//        let newItem3 = Item()
//        newItem3.title = "322"
//        itemsArray.append(newItem3)
       
        
        
//        if let items = userDefault.array(forKey: "ToDoListArray") as? [Item]{
//           itemsArray = items
//        }
//
    }
    
    
    //MARK: - Table Data Source Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        let item = itemsArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        
         cell.accessoryType = item.done   ? .checkmark : .none //cternary operator expression  // value = boolCondition ? valueIfTrue : valueIfFalse
        
        
        // The old way of changing the value
//        if itemsArray[indexPath.row].done == true {
//
//            cell.accessoryType = .checkmark
//        }
//        else{
//            cell.accessoryType = .none
//        }
        
        
        return cell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsArray.count
    }
    
    
//Mark - Table Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
        tableView.deselectRow(at: indexPath, animated: true) // for adding animation to de seleting cells
        
        itemsArray[indexPath.row].done = !itemsArray[indexPath.row].done//to reverse the result of the done property
        
           //>>This is how to delete an item from the table view and from core data
           //>>Notice: this should be the in order to work
//        context.delete(itemsArray[indexPath.row])
//        itemsArray.remove(at: indexPath.row)
        
        
        
        //This is the old direct method changing the accessories properities
//        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark{
//
//            tableView.cellForRow(at: indexPath)?.accessoryType = .none
//
//        }
//        else{
//
//            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
//
//        }
        saveItems()
        
        }
    
    //MARK: - Add new Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new item to the list", message: "" , preferredStyle: .alert )
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //What will happen once the useer click the add Item button on our UIAlert
            
            
        let newItem = Item(context: self.context)
            
        newItem.title = textField.text!
        newItem.done = false
        newItem.parentCategory = self.selectedCategory
        self.itemsArray.append(newItem)
            
        self.saveItems()
            
        
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
            
           // print(alertTextField.text!)
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    
    //    MARK: - Model Manupilation Methods
func saveItems(){
    
        do{
        try  context.save()
        }
        catch{
            print("Error saving context  : \(error)")
        }
        tableView.reloadData()
        
    }
    
    
    func loadItems(with request : NSFetchRequest<Item> = Item.fetchRequest(), predicate : NSPredicate?  = nil){
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let additionalPredicate = predicate{
           request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate , additionalPredicate])
        }
        else{
          request.predicate = categoryPredicate
        }
        
        
        do{
            try itemsArray = context.fetch(request)
        }
        catch{
            print("Error while fetching data:\(error)")
        }
        tableView.reloadData()
    }
    
}

//MARK : - Search Bar Methods

extension TodoListViewController : UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request , predicate: predicate)
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            
            loadItems()
            
            DispatchQueue.main.async {
                
                searchBar.resignFirstResponder() //search bar should not be the thing that is currently selected

            }
        }
    }
    
}

