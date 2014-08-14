//
//  TaskManagerViewController.swift
//  TaskManager
//
//  Created by Ravi Shankar on 12/07/14.
//  Copyright (c) 2014 Ravi Shankar. All rights reserved.
//

import UIKit
import CoreData

class TaskManagerViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    //set up the managedObjectContext
    let managedObjectContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext
    //and fetchedResultController (which is an instance of NSFetchedResultsController)
    var fetchedResultController: NSFetchedResultsController = NSFetchedResultsController()

    override func viewDidLoad() {
       //call the superclass
        super.viewDidLoad()
       // call getFetchedResultController and change the value of fetchedResultController
        fetchedResultController = getFetchedResultController()
        //set the delegate to self
        fetchedResultController.delegate = self
        //perform the fetch
        fetchedResultController.performFetch(nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        if segue.identifier == "edit" {
            let cell = sender as UITableViewCell
            let indexPath = tableView.indexPathForCell(cell)
            let taskController:TaskDetailViewController = segue.destinationViewController as TaskDetailViewController
            let task:Tasks = fetchedResultController.objectAtIndexPath(indexPath) as Tasks
            taskController.task = task
            
            let task2:Tasks = fetchedResultController.objectAtIndexPath(indexPath) as Tasks
            taskController.task2 = task2
        }
    }
    
    
    func getFetchedResultController() -> NSFetchedResultsController {
        //call to taskFetchRequest
        fetchedResultController = NSFetchedResultsController(fetchRequest: taskFetchRequest(), managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        return fetchedResultController
    }
    //defines the fetch request
    func taskFetchRequest() -> NSFetchRequest {
      //specify the entity
        let fetchRequest = NSFetchRequest(entityName: "Tasks")
        //2 sort descriptors
        let sortDescriptor = NSSortDescriptor (key: "desc", ascending : false)
        let sortDescriptor2 = NSSortDescriptor (key: "desc2",ascending : false)
        //let sortDescriptor = NSSortDescriptor(key: "desc", ascending: true)
        //add the sort descriptors to the fetch request
        fetchRequest.sortDescriptors = [sortDescriptor, sortDescriptor2]
        return fetchRequest
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // #pragma mark - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
        return fetchedResultController.sections.count
    }
    
    override func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultController.sections[section].numberOfObjects
    }
    
    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell? {
        var cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
        let task = fetchedResultController.objectAtIndexPath(indexPath) as Tasks
        cell.textLabel.text = task.desc
        cell.detailTextLabel.text = task.desc2
        //let task2 = fetchedResultController.objectAtIndexPath(indexPath) as Tasks
        //cell.detailTextLabel.text = task2.desc
        return cell
    }
    
    override func tableView(tableView: UITableView!, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath!) {
        let managedObject:NSManagedObject = fetchedResultController.objectAtIndexPath(indexPath) as NSManagedObject
        managedObjectContext.deleteObject(managedObject)
        managedObjectContext.save(nil)
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController!) {
        tableView.reloadData()
    }
}
