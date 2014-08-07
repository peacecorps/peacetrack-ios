//
//  TaskDetailViewController.swift
//  TaskManager
//
//  Created by Ravi Shankar on 12/07/14.
//  Copyright (c) 2014 Ravi Shankar. All rights reserved.
//

import UIKit
import CoreData

class TaskDetailViewController: UIViewController {

    let managedObjectContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext
    
    @IBOutlet var txtDesc: UITextField!
    
    var task: Tasks? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if task != nil {
            txtDesc.text = (task as Tasks!).desc  //added the !
        }
    }
    
    @IBAction func done(sender: AnyObject) {
        if task != nil {
            editTask()
        } else {
            createTask()
        }
        dismissViewController()
    }
    
    @IBAction func cancel(sender: AnyObject) {
         dismissViewController()
    }
    
    func dismissViewController() {
        navigationController.popViewControllerAnimated(true)
    }
    
    func createTask() {
        let entityDescripition = NSEntityDescription.entityForName("Tasks", inManagedObjectContext: managedObjectContext)
        let task = Tasks(entity: entityDescripition, insertIntoManagedObjectContext: managedObjectContext)
        task.desc = txtDesc.text
        managedObjectContext.save(nil)
    }
    
    func editTask() {
        (task as Tasks!).desc = txtDesc.text //added the !
        managedObjectContext.save(nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
