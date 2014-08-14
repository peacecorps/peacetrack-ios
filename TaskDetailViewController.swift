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
    
    //outlets for the text fields
    @IBOutlet var txtDesc: UITextField!
    @IBOutlet var txtDesc2: UITextField!
    
    //instances of Tasks entity
    var task: Tasks? = nil
    var task2: Tasks? = nil
    
    //get the right text in the boxes
    override func viewDidLoad() {
       //call the superview
        super.viewDidLoad()
       
        // if there's something in the task text from the object store
        if task != nil{
           //set the text in the text box to be this text
            txtDesc.text = (task as Tasks!).desc  //added the !
         
                  }
        // if there's something in the task2 text from the object store
        if task2 != nil{
            //set the text in the second text box to be this text
            txtDesc2.text = (task2 as Tasks!).desc2
        }
    }
    
    //when done (or submmit) button is pressed
    @IBAction func done(sender: AnyObject) {
      //if the user presses done and there's something in either box right off the bat, call editTask()
       
        if task != nil && task2 != nil{
            editTask()
        } else {
          //but if there's not something in either box right off the bat, call createTask()
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
    
    //basically, create means you need to allocate a space in the object store for this object, then save it there
    func createTask() {
       //grab the entity description
        let entityDescription = NSEntityDescription.entityForName("Tasks", inManagedObjectContext: managedObjectContext)
        //assign task variable to hav a place in the object store
        let task = Tasks(entity: entityDescription, insertIntoManagedObjectContext: managedObjectContext)
        //set desc in the store to be the user's text from txtDesc text box
        task.desc = txtDesc.text
       //set desc2 in the store to be the user's text from txtDesc2 text box
        task.desc2 = txtDesc2.text
        //save the new Tasks object
        managedObjectContext.save(nil)
       
        
    }
    
        func editTask() {
       //figure out where the object is in the data store, and edit it
        (task as Tasks!).desc = txtDesc.text //added the !
        (task2 as Tasks!).desc2 = txtDesc2.text
        //save the edited Tasks object
        managedObjectContext.save(nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
