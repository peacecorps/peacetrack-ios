//  VCMain.swift
//  swiftPeaceTrack<3
//
//  Created by Shelagh McGowan on 7/4/14.
//  Copyright (c) 2014 Shelagh McGowan. All rights reserved.
//  Citing https://github.com/GabrielMassana/Picker-iOS8 :Picker menu views code


import Foundation
import UIKit
import CoreData

class VCMain: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, NSURLConnectionDelegate{
    
    //configure text boxes
    @IBOutlet var txtFullName: UITextField!
    @IBOutlet var txtVolunteerID: UITextField!
    
    //instantiate 2 picker views
    var countryPicker = UIPickerView()
    var sectorPicker = UIPickerView()
    
    //instantiate 2 NSArrays
    var countryPickerData  = NSArray()
    var sectorPickerData = NSArray()
    
    //instantiate 2 NSMutabaleArrays
    var countriesArray: NSMutableArray =  NSMutableArray()
    var sectorsArray: NSMutableArray = NSMutableArray()
    
    //create 2 labels to show picker view selection
    @IBOutlet var countryLabel : UILabel! = nil
    @IBOutlet var sectorLabel : UILabel! = nil
    
    //declare the initial view and window
    var actionView: UIView = UIView()
    var window: UIWindow? = nil
    //this is related to the fields in the 'create account' view
    //but it's also resetting the value every time the app is launched, I think, which doesn't really matter cuz this view is only seen once anyway.
    var empty: Bool = true
    
    //how do I declare this without it being true or false right off the bat? This boolean is false if the VCMain view hasn't been viewed before, and true if it has. Used in the view did load method to determine whether the segue occurs or not.
    var viewed: Bool = false
    
    //what happens when the root view loads
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // This is a rogue way not to show the create account screen to the user more than once. Will need to replace with a better way, or simply with a less animated segue(using NSUserDefaults? Swift?)
        
        if viewed == true{
            self.performSegueWithIdentifier("mySegue", sender: self)
        }
        var delegate = UIApplication.sharedApplication()
        //We have an array of views here
        var myWindow: UIWindow? = delegate.keyWindow
        var myWindow2: NSArray = delegate.windows
        if let myWindow: UIWindow = UIApplication.sharedApplication().keyWindow
        {
            window = myWindow
        }
        else         {
            window = myWindow2[0] as? UIWindow
        }
        countryPicker.backgroundColor = UIColor.whiteColor()
        sectorPicker.backgroundColor = UIColor.whiteColor()
        actionView.frame = CGRectMake(0, UIScreen.mainScreen().bounds.size.height.0, UIScreen.mainScreen().bounds.size.width, 260.0)
        //two variables to hold the plists
        var filePath =  NSBundle.mainBundle().pathForResource("Property List", ofType: "plist")
        var filePath2 = NSBundle.mainBundle().pathForResource("sectors", ofType: "plist")
        //Add the contents of filePath (PropertyList.plist) to the NSMutableArray "countriesArray".
        countriesArray = NSMutableArray(contentsOfFile: filePath)
        //Add the contents of filePath2 (sectors.plist) to the NSMutableArray "sectorsArray"
        sectorsArray =  NSMutableArray(contentsOfFile: filePath2)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //conditionally creates a new user object and saves it to the database. also prints out the object in the console.
    @IBAction func addAccount(){
        //create a new variable appDel to store app delegate
        //cast delegate of type UIApplication to our delegate type AppDelegate
        var appDel:AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
        //get our ManagedObjectContext from our app delegate. now we are able to save and load information from our SQLite file.
        var context:NSManagedObjectContext = appDel.managedObjectContext
        //make a new user object that will be inserting itself into the database
        //cast it back to an NSManagedObject
        var newUser = NSEntityDescription.insertNewObjectForEntityForName("Users", inManagedObjectContext: context) as NSManagedObject
        newUser.setValue(""+txtFullName.text, forKey: "username")
        newUser.setValue(""+txtVolunteerID.text, forKey: "password")
        newUser.setValue(""+countryLabel.text, forKey: "post")
        newUser.setValue(""+sectorLabel.text, forKey: "sector")
        
        //if all the fields are full...
        if txtFullName.text != "" && txtVolunteerID.text != "" && countryLabel.text != "No country" && sectorLabel.text != "No sector" {
            //empty is no longer true
            empty==false
            //save the object
            context.save(nil)
            //print object to the console
            println(newUser)
            println("Object Saved")
            //perfom the custom segue
            self.performSegueWithIdentifier("mySegue", sender: self)
            //perhaps this is a better place to set viewed to true? only if user has created an account will they not see the create account view. Sounds like a good plan lol
            //viewed = true
        }
        else{
            //show the alert view
            var myAlertView = UIAlertView()
            myAlertView.title = "Can't Create Account"
            myAlertView.message = "Please Fill All Fields"
            myAlertView.addButtonWithTitle("OK")
            myAlertView.show()
        }
    }
    
    /***overrides the prepareForSegue method so that I can use it for mySegue to call my segue (from create account screen to home screen) programmatically instead of using storyboard.***/
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        if segue.identifier == "mySegue"{
        }
    }
    
    @IBAction func openCountryPicker(sender : UIButton)
    {
        let kSCREEN_WIDTH  =    UIScreen.mainScreen().bounds.size.width
        countryPicker.frame = CGRectMake(0.0, 44.0,kSCREEN_WIDTH, 216.0)
        countryPicker.dataSource = self
        countryPicker.delegate = self
        countryPicker.showsSelectionIndicator = true;
        countryPicker.backgroundColor = UIColor.whiteColor()
        var pickerDateToolbar = UIToolbar(frame: CGRectMake(0, 0, 320, 44))
        pickerDateToolbar.barStyle = UIBarStyle.Black
        pickerDateToolbar.barTintColor = UIColor.grayColor()
        pickerDateToolbar.translucent = true
        var barItems = NSMutableArray()
        var labelCancel = UILabel()
        labelCancel.text = "Cancel"
        var titleCancel = UIBarButtonItem(title: labelCancel.text, style: UIBarButtonItemStyle.Plain, target: self, action: Selector("cancelPickerSelectionButtonClicked:"))
        titleCancel.tintColor = UIColor.whiteColor()
        barItems.addObject(titleCancel)
        var flexSpace: UIBarButtonItem
        flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: self, action: nil)
        barItems.addObject(flexSpace)
        countryPickerData = countriesArray
        countryPicker.selectRow(1, inComponent: 0, animated: false)
        let doneBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: Selector("countryDoneClicked:"))
        doneBtn.tintColor = UIColor.whiteColor()
        barItems.addObject(doneBtn)
        pickerDateToolbar.setItems(barItems, animated: true)
        actionView.addSubview(pickerDateToolbar)
        actionView.addSubview(countryPicker)
        if (window != nil) {
            window!.addSubview(actionView)
        }
        else
        {
            self.view.addSubview(actionView)
        }
        UIView.animateWithDuration(0.2, animations: {
            
            self.actionView.frame = CGRectMake(0, UIScreen.mainScreen().bounds.size.height - 260.0, UIScreen.mainScreen().bounds.size.width, 260.0)
        })
    }
    
    @IBAction func openSectorPicker(sender : UIButton)
    {
        let kSCREEN_WIDTH  =    UIScreen.mainScreen().bounds.size.width
        sectorPicker.frame = CGRectMake(0.0, 44.0,kSCREEN_WIDTH, 216.0)
        sectorPicker.dataSource = self
        sectorPicker.delegate = self
        sectorPicker.showsSelectionIndicator = true;
        sectorPicker.backgroundColor = UIColor.whiteColor()
        var pickerDateToolbar = UIToolbar(frame: CGRectMake(0, 0, 320, 44))
        pickerDateToolbar.barStyle = UIBarStyle.Black
        pickerDateToolbar.barTintColor = UIColor.grayColor()
        pickerDateToolbar.translucent = true
        var barItems = NSMutableArray()
        var labelCancel = UILabel()
        labelCancel.text = "Cancel"
        var titleCancel = UIBarButtonItem(title: labelCancel.text, style: UIBarButtonItemStyle.Plain, target: self, action: Selector("cancelPickerSelectionButtonClicked:"))
        titleCancel.tintColor = UIColor.whiteColor()
        barItems.addObject(titleCancel)
        var flexSpace: UIBarButtonItem
        flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: self, action: nil)
        barItems.addObject(flexSpace)
        sectorPickerData = sectorsArray
        sectorPicker.selectRow(1, inComponent: 0, animated: false)
        let doneBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: Selector("sectorDoneClicked:"))
        doneBtn.tintColor = UIColor.whiteColor()
        barItems.addObject(doneBtn)
        pickerDateToolbar.setItems(barItems, animated: true)
        actionView.addSubview(pickerDateToolbar)
        actionView.addSubview(sectorPicker)
        if (window != nil) {
            window!.addSubview(actionView)
        }
        else
        {
            self.view.addSubview(actionView)
        }
        UIView.animateWithDuration(0.2, animations: {
            self.actionView.frame = CGRectMake(0, UIScreen.mainScreen().bounds.size.height - 260.0, UIScreen.mainScreen().bounds.size.width, 260.0)
        })
    }
    
    
    //also working for country picker cancel button
    func cancelPickerSelectionButtonClicked(sender: UIBarButtonItem) {
        UIView.animateWithDuration(0.2, animations: {
            self.actionView.frame = CGRectMake(0, UIScreen.mainScreen().bounds.size.height, UIScreen.mainScreen().bounds.size.width, 260.0)
            }, completion: { _ in
                for obj: AnyObject in self.actionView.subviews {
                    if let view = obj as? UIView
                    {
                        view.removeFromSuperview()
                    }
                }
        })
    }
    
    func countryDoneClicked(sender: UIBarButtonItem) {
        
        var myRow = countryPicker.selectedRowInComponent(0)
        countryLabel.text = countryPickerData.objectAtIndex(myRow) as NSString
        UIView.animateWithDuration(0.2, animations: {
            self.actionView.frame = CGRectMake(0, UIScreen.mainScreen().bounds.size.height, UIScreen.mainScreen().bounds.size.width, 260.0)
            }, completion: { _ in
                for obj: AnyObject in self.actionView.subviews {
                    if let view = obj as? UIView
                    {
                        view.removeFromSuperview()
                    }
                }
        })
    }
    
    func sectorDoneClicked(sender: UIBarButtonItem) {
        
        var myRow = sectorPicker.selectedRowInComponent(0)
        sectorLabel.text = sectorPickerData.objectAtIndex(myRow) as NSString
        UIView.animateWithDuration(0.2, animations: {
            self.actionView.frame = CGRectMake(0, UIScreen.mainScreen().bounds.size.height, UIScreen.mainScreen().bounds.size.width, 260.0)
            }, completion: { _ in
                for obj: AnyObject in self.actionView.subviews {
                    if let view = obj as? UIView
                    {
                        view.removeFromSuperview()
                    }
                }
        })
    }
    
    // MARK - Picker delegate
    
    //sets up the number of rows in the component
    func pickerView(_pickerView: UIPickerView!, numberOfRowsInComponent component: Int) -> Int {
        var returnNumb: Int = 0
        if (_pickerView == countryPicker)
        {
            returnNumb=countryPickerData.count
        }
        else if (_pickerView == sectorPicker){
            returnNumb=sectorPickerData.count
        }
        return returnNumb
    }
    
    //sets up the number of componenets in the picker view
    func numberOfComponentsInPickerView(_pickerView: UIPickerView!) -> Int {
        return 1
    }
    
    //sets up the titles for each row in the component
    //changed "func PickerView to func pickerView to fix bug with "?" showing up instead of proper string in the picker view
    func pickerView(_pickerView: UIPickerView!, titleForRow row: Int, forComponent component: Int) -> String! {
        var returnStr: NSString = "";
        if (_pickerView == countryPicker)
        {
            returnStr=countryPickerData.objectAtIndex(row) as NSString
        }
        else if (_pickerView == sectorPicker){
            returnStr=sectorPickerData.objectAtIndex(row) as NSString
        }
        return ""+returnStr
    }
    
}

