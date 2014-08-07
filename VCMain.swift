//  VCMain.swift
//  swiftPeaceTrack<3
//
//  Created by Shelagh McGowan on 7/4/14.
//  Copyright (c) 2014 Shelagh McGowan. All rights reserved.
//  Citing https://github.com/GabrielMassana/Picker-iOS8 :Picker menu views code


import Foundation
import UIKit
import CoreData




class VCMain: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, NSURLConnectionDelegate {
   
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
    
 
    
   
    
    
    
    
    
    
    
    
    /***What happens when the root view loads.
    
    ***/
    override func viewDidLoad() {
        super.viewDidLoad()
       
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
       
        //set the background colors of the picker views
        countryPicker.backgroundColor = UIColor.whiteColor()
        sectorPicker.backgroundColor = UIColor.whiteColor()
        
        //set up the frame of one action view (issue -why is there only one action view?)
        actionView.frame = CGRectMake(0, UIScreen.mainScreen().bounds.size.height.0, UIScreen.mainScreen().bounds.size.width, 260.0)
       
        //two variables to hold the plists
        var filePath =  NSBundle.mainBundle().pathForResource("Property List", ofType: "plist")
        var filePath2 = NSBundle.mainBundle().pathForResource("sectors", ofType: "plist")
        
        //Add the contents of filePath file to the NSMutableArray "countriesArray".
        countriesArray = NSMutableArray(contentsOfFile: filePath)
        
        countriesArray.insertObject("", atIndex: 0)
        countriesArray.insertObject("No country", atIndex: 0)
        //deleted pickel object at index one (cus wtf shelagh? lol)
        //Add the contents of filePath2 file to the NSMutableArray "sectorsArray"
        sectorsArray =  NSMutableArray(contentsOfFile: filePath2)
        sectorsArray.insertObject("", atIndex: 0)
        sectorsArray.insertObject("No sector", atIndex: 0)
    
    }
    
  
    
    
    
    
    
    
    //API code
    /*  override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        startConnection()
    }*/
    
    
    
    
    
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
         // Dispose of any resources that can be recreated.
    }

   
    
    
    
    
    
    
    //creates a new user object and saves it to the database. also prints out the object for you to see.
    @IBAction func btnLoginAndSave(){
        
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
                newUser.setValue(""+countryLabel.text, forKey:"post")
                newUser.setValue(""+sectorLabel.text, forKey:"sector")
                //save the object
                context.save(nil)
                //placeholder to show an error message
               //print object to the console
                println(newUser)
                println("Object Saved")
                //test case
                //println("save button pressed \(txtFullName.text)")
        
            }
    
    
    
    
    
    
    
    
    //just a test to see loading of all user objects in database in the console
    
    @IBAction func btnLoadTest(){
        
                //same as btnSave() function
                var appDel:AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
                //same as btnSave() function
                var context:NSManagedObjectContext = appDel.managedObjectContext
                //asking database to perform a request on the user's table
                var request = NSFetchRequest(entityName: "Users")
                    //fixes a bug (optional) objects were always coming back as false.
                    request.returnsObjectsAsFaults = false;
                //ask the context to execute a fetch request. errors will be handled here.
                var results:NSArray = context.executeFetchRequest(request, error: nil)
                //if there are results, loop through them and print them to the console
                if(results.count > 0){
                        for res in results{
                                println(res)
                            }
                    }else{
                        println("0 Results Returned...Potential Error")
                    }
                //test case
                //println("load button pressed \(txtVolunteerID.text)")
        
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
        barItems.addObject(titleCancel)
        
        var flexSpace: UIBarButtonItem
        flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: self, action: nil)
        barItems.addObject(flexSpace)
        
        countryPickerData = countriesArray
        countryPicker.selectRow(1, inComponent: 0, animated: false)
        
        let doneBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: Selector("countryDoneClicked:"))
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
        barItems.addObject(titleCancel)
        
        var flexSpace: UIBarButtonItem
        flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: self, action: nil)
        barItems.addObject(flexSpace)
        
        sectorPickerData = sectorsArray
       
        sectorPicker.selectRow(1, inComponent: 0, animated: false)
        
        let doneBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: Selector("sectorDoneClicked:"))
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
        
        if countryLabel.text == "" {
            countryLabel.text = "No country"
            

        }
        
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
   
    //Whackky wack wack quack
    
    
    
    
    
    
    
    
    
    func sectorDoneClicked(sender: UIBarButtonItem) {
        
        var myRow = sectorPicker.selectedRowInComponent(0)
        sectorLabel.text = sectorPickerData.objectAtIndex(myRow) as NSString
        
        if sectorLabel.text == "" {
            sectorLabel.text = "No country"
        }
        
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
    
    
    
    //  WHEN ARE THESE METHODS CALLED
    
    
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
    func PickerView(_pickerView: UIPickerView!, titleForRow row: Int, forComponent component: Int) -> String! {
     
      
        //need to append to the string
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
   
       /* if(countryPickerData == countriesArray){
          
            pl=countryPickerData.objectAtIndex(row) as NSString
        }
        else{
           
            pl=sectorPickerData.objectAtIndex(row) as NSString
        }
        return pl
    }*/

   
   
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    /****API connection code
    
    @lazy var data = NSMutableData()
    
    
    func startConnection(){
        let urlPath: String = "http://lacedwithperfectsmiles.tumblr.com"
        var url: NSURL = NSURL(string: urlPath)
        var request: NSURLRequest = NSURLRequest(URL: url)
        var connection: NSURLConnection = NSURLConnection(request: request, delegate: self, startImmediately: false)
        connection.start()
    }
    
    func connection(connection: NSURLConnection!, didReceiveData data: NSData!){
        self.data.appendData(data)
    }
    
    func buttonAction(sender: UIButton!){
        startConnection()
    }
    
    func connectionDidFinishLoading(connection: NSURLConnection!) {
        var err: NSError
        // throwing an error on the line below (can't figure out where the error message is)
        var jsonResult: NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as NSDictionary
        println(jsonResult)
    }
    
    func getJSON(urlToRequest: String) -> NSData{
        return NSData(contentsOfURL: NSURL(string: urlToRequest))
    }
    
    func parseJSON(inputData: NSData) -> NSDictionary{
        var error: NSError?
        var boardsDictionary: NSDictionary = NSJSONSerialization.JSONObjectWithData(inputData, options: NSJSONReadingOptions.MutableContainers, error: &error) as NSDictionary
        
        return boardsDictionary
    }
}*****/
}
    