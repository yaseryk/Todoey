//
//  CategoryViewCellTableViewController.swift
//  Todoey
//
//  Created by Yaser on 01/05/2018.
//  Copyright © 2018 YaserYK. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewCellTableViewController: UITableViewController {
    
    let categoryContext = (UIApplication.shared.delegate as!AppDelegate).persistentContainer.viewContext
    
    var categoryArray = [Category]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategory()
        
    }
   
    //MARK:- TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        let category = categoryArray[indexPath.row]
        
       cell.textLabel?.text = category.name
        
        return cell
    }
    //MARK:- TableView Delegate Methods

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
    }
    
    
    //MARK:- Data Manipulation Methods
    
    func saveCategory() {
        
        do{
            try categoryContext.save()

        }
        catch{
            print("Error while saving data : \(error)")
        }
        tableView.reloadData()
    }
    
    func loadCategory(with request : NSFetchRequest<Category> = Category.fetchRequest()){
        
        //categoryContext.fetch(request)
        do{
            try categoryArray = categoryContext.fetch(request)
        }
        catch{
            print("Error while fetching Categories : \(error)")
        }
        tableView.reloadData()
    }

    //MARK:- Add New Categories


    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let newCategory = Category(context: self.categoryContext)
            
            newCategory.name = textField.text!
            
            self.categoryArray.append(newCategory)
            
            self.saveCategory()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add new category"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    

    
}
