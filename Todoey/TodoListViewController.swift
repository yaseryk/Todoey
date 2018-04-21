//
//  ViewController.swift
//  Todoey
//
//  Created by Yaser on 19/04/2018.
//  Copyright © 2018 YaserYK. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    let itemsArray = ["Buy Milk" , "Go to gym" , "Find Mike" ]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    //MARK: - Table Data Source Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        cell.textLabel?.text = itemsArray[indexPath.row]
        
        return cell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsArray.count
    }
    
    //Mark - Table Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark{
            
            tableView.cellForRow(at: indexPath)?.accessoryType = .none

        }
        else{
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark

        }

        
        print(itemsArray[indexPath.row])
    }


}

