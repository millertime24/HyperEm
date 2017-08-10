//
//  DailyViewController.swift
//  HG
//
//  Created by Andrew on 7/10/17.
//  Copyright © 2017 Andrew. All rights reserved.
//

import UIKit
import CoreData


class DailyViewController: UIViewController, BEMCheckBoxDelegate {
    
    
    var days: [Day] = []
    
    var selectedDate: Date!
    //var selectedDay: Day!
    
    var thisDay: Day!
    
    var weightlb: Int = 120
    
    @IBOutlet weak var box: BEMCheckBox!
    
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var weightUnit: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        print("viewDidLoad dailyView")
        //weightUnit.text = String(selectedDay.weight)
        
        // Customise the nav bar
        let navBar = self.navigationController?.navigationBar
        navBar!.barTintColor = UIColor.black
        navBar!.tintColor = UIColor.white
        navBar!.isTranslucent = false
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
        
        box.delegate = self
        
        // returns the current date in Weekday, Month Day format
        dateLabel.text = convertDate(initialDate: selectedDate)
        
        
    }
    
    
    
    func didTap(_ checkBox: BEMCheckBox) {
        print("box tapped")
        
        // set the value for bowel property
        // if it is true , set to false
        //if it is false, set its value to true
        
        //if it is false, set its value to true
        if thisDay.bowel == false {
            thisDay.setValue(true, forKey: "bowel")
        } else {
            //if it is true , set to false
            thisDay.setValue(false, forKey: "bowel")
            //
        }
        //save core data
        let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        do {
            try managedContext.save()
        }catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
        
        
    }
    
    // returns Date in the user's timezone
    func fixDateThing() -> Date {
        let utcDate = Date()
        let timeZoneSeconds = NSTimeZone.local.secondsFromGMT(for: Date())
        let localDate = utcDate.addingTimeInterval(TimeInterval(timeZoneSeconds))
        return localDate
    }
    
    // convert date
    func convertDate(initialDate: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMMM d"
        let convertedDate = dateFormatter.string(from:initialDate)
        return convertedDate
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // save data
        if segue.identifier == "WeightSegue" {
            if let destination = segue.destination as? WeightViewController {
                destination.selectedDay = thisDay
            }
            
        } else if segue.identifier == "NotesSegue" {
            if let destination = segue.destination as? NotesViewController {
                destination.selectedDay = thisDay
            }
            
            
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Setting up Core Data
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Day")
        // Add predicate for day.dat == selectedDate
        let predicate = NSPredicate(format: "date == %@", argumentArray: [selectedDate])
        fetchRequest.predicate = predicate
        
        do {
            days = try managedContext.fetch(fetchRequest) as! [Day]
            if days.count == 0 {
                // create new Day
                
                let managedContext = appDelegate.persistentContainer.viewContext
                
                
                let entity = NSEntityDescription.entity(forEntityName: "Day", in: managedContext)!
                thisDay = NSManagedObject(entity: entity, insertInto: managedContext) as! Day
                thisDay.setValue(true, forKey: "notEntered")
                thisDay.setValue(selectedDate, forKeyPath: "date")
                
                do {
                    try managedContext.save()
                } catch let error as NSError {
                    print("Could not save. \(error), \(error.userInfo)")
                }
                print("must make new day")
            } else {
                // use this for the ui
                print("found a day")
                thisDay = days[0]
                weightUnit.text = ("\(thisDay.weight) lbs")
                // set the image
                // if bowel == true  // set the check mark image
                //if it is false , do not do anything
                if thisDay.bowel == true {
                    box.setOn(true, animated: true)
                }
                
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        
    }
    
}
